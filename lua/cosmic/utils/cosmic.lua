local M = {}

local lockfile = 'lazy-lock.json'
local max_listed_commits = 10

-- Restore in a fresh headless Neovim: the running lazy.nvim has cached the old lockfile and plugin specs.
-- `-c` commands run before VimEnter, so VimEnter/VeryLazy plugins such as auto-session never load here.
-- lazy.nvim does not flag failed checkouts as errors, so verify each plugin's HEAD against the lockfile.
local restore_script = [[
lua local ok, failed = pcall(function()
  local Config = require('lazy.core.config')
  local file = assert(io.open(Config.options.lockfile, 'rb'))
  local content = file:read('*a')
  file:close()
  local lock = vim.json.decode(content)

  require('lazy').restore({ wait = true, show = false })

  -- lazy.nvim rewrites the lockfile even after failed checkouts; keep the pulled version for retries.
  file = assert(io.open(Config.options.lockfile, 'wb'))
  file:write(content)
  file:close()

  local names = {}
  for name, entry in pairs(lock) do
    local plugin = Config.plugins[name]
    if plugin and not plugin._.is_local then
      local head = vim.uv.fs_stat(plugin.dir)
        and vim.system({ 'git', 'rev-parse', 'HEAD' }, { cwd = plugin.dir, text = true }):wait()
      if not head or head.code ~= 0 or vim.trim(head.stdout) ~= entry.commit then
        table.insert(names, name)
      end
    end
  end
  table.sort(names)
  return names
end)
if not ok or #failed > 0 then
  io.stderr:write(ok and ('Failed to restore: ' .. table.concat(failed, ', ')) or tostring(failed))
  vim.cmd('cquit 1')
end
vim.cmd('qall!')
]]

function M.get_install_dir()
  local config_dir = os.getenv('COSMICNVIM_INSTALL_DIR')
  if not config_dir then
    return vim.fn.stdpath('config')
  end
  return config_dir
end

---@param message string
---@param result vim.SystemCompleted
local function notify_failure(message, result)
  local details = vim.trim(result.stderr or '')
  if details == '' then
    details = vim.trim(result.stdout or '')
  end
  message = ('%s (exit code %s).'):format(message, result.code)
  if details ~= '' then
    message = message .. '\n' .. details
  end
  vim.notify(message, vim.log.levels.ERROR)
end

---@param co thread
local function resume(co, ...)
  local ok, err = coroutine.resume(co, ...)
  if not ok then
    vim.notify(('CosmicNvim update failed:\n%s'):format(err), vim.log.levels.ERROR)
  end
end

--- Run a command from the update coroutine without blocking the editor.
---@param cmd string[]
---@param opts vim.SystemOpts
---@return vim.SystemCompleted
local function run(cmd, opts)
  local co = assert(coroutine.running(), 'run() must be called from a coroutine')
  local ok, err = pcall(vim.system, cmd, opts, function(result)
    vim.schedule(function()
      resume(co, result)
    end)
  end)
  if not ok then
    return { code = -1, signal = 0, stdout = '', stderr = tostring(err) }
  end
  return coroutine.yield()
end

---@param path string
---@param args string[]
---@return vim.SystemCompleted
local function git(path, args)
  -- Fail instead of prompting for credentials on the editor's terminal.
  return run(vim.list_extend({ 'git' }, args), { cwd = path, text = true, env = { GIT_TERMINAL_PROMPT = '0' } })
end

--- `git diff --quiet` exits 1 when files differ and higher on errors.
---@param path string
---@param args string[]
---@return boolean|nil changed, vim.SystemCompleted result
local function git_changed(path, args)
  local result = git(path, vim.list_extend({ 'diff', '--quiet' }, args))
  if result.code > 1 or result.code < 0 then
    return nil, result
  end
  return result.code == 1, result
end

---@param commits string
---@return string
local function summarize_commits(commits)
  local lines = vim.split(commits, '\n', { trimempty = true })
  local summary = table.concat(vim.list_slice(lines, 1, max_listed_commits), '\n')
  if #lines > max_listed_commits then
    summary = ('%s\n…and %d more'):format(summary, #lines - max_listed_commits)
  end
  return summary
end

local function restore_plugins()
  vim.notify('Restoring plugins to the updated lockfile...')
  local result = run({ vim.v.progpath, '--headless', '-i', 'NONE', '-c', restore_script }, { text = true })
  if result.code ~= 0 then
    notify_failure('Plugin restore failed. Restart Neovim and run :Lazy restore to retry', result)
    return
  end
  vim.notify('Plugins restored. Restart Neovim to load the changes.')
end

---@param path string
local function update(path)
  local fetch = git(path, { 'fetch', '--quiet' })
  if fetch.code ~= 0 then
    return notify_failure(('Could not fetch CosmicNvim updates in %s'):format(path), fetch)
  end

  local log = git(path, { 'log', '--oneline', '--no-decorate', 'HEAD..@{upstream}' })
  if log.code ~= 0 then
    return notify_failure(('Could not compare CosmicNvim with its upstream branch in %s'):format(path), log)
  end
  local commits = vim.trim(log.stdout or '')
  if commits == '' then
    vim.notify('CosmicNvim is already up to date.')
    return
  end

  local lockfile_updated, diff = git_changed(path, { 'HEAD', '@{upstream}', '--', lockfile })
  if lockfile_updated == nil then
    return notify_failure(('Could not check %s for upstream changes'):format(lockfile), diff)
  end

  -- `:Lazy update` rewrites the tracked lockfile, which blocks fast-forwarding when upstream changed it too.
  if lockfile_updated then
    local lockfile_dirty, status = git_changed(path, { 'HEAD', '--', lockfile })
    if lockfile_dirty == nil then
      return notify_failure(('Could not check %s for local changes'):format(lockfile), status)
    end

    if lockfile_dirty then
      local choice = vim.fn.confirm(
        ('%s has local plugin updates, and this CosmicNvim update changes it too.\n'):format(lockfile)
          .. 'Discard the local lockfile changes and continue?',
        '&Discard and update\n&Cancel',
        2
      )
      if choice ~= 1 then
        vim.notify('CosmicNvim update cancelled. Local lockfile changes were kept.', vim.log.levels.WARN)
        return
      end

      local reset = git(path, { 'checkout', 'HEAD', '--', lockfile })
      if reset.code ~= 0 then
        return notify_failure(('Could not discard local changes to %s'):format(lockfile), reset)
      end
    end
  end

  local merge = git(path, { 'merge', '--ff-only', '@{upstream}' })
  if merge.code ~= 0 then
    return notify_failure(('CosmicNvim update failed in %s'):format(path), merge)
  end

  vim.notify(('CosmicNvim updated:\n%s\n\nRestart Neovim to load the changes.'):format(summarize_commits(commits)))

  if not lockfile_updated then
    return
  end

  local choice =
    vim.fn.confirm('The plugin lockfile changed. Restore plugins to the updated versions now?', '&Restore\n&Later', 1)
  if choice == 1 then
    restore_plugins()
  else
    vim.notify('Restart Neovim and run :Lazy restore to update plugins to the new lockfile.')
  end
end

-- Update CosmicNvim without blocking the editor or reloading live configuration.
function M.update()
  local path = M.get_install_dir()
  vim.notify('Updating CosmicNvim...')
  resume(coroutine.create(update), path)
end

return M
