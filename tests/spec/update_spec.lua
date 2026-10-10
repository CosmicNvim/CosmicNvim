local T = require('tests.harness')

-- Identity and config for fixture commits; the developer's global git config could sign or hook them.
local git_env = {
  GIT_AUTHOR_NAME = 'Cosmic Test',
  GIT_AUTHOR_EMAIL = 'test@example.com',
  GIT_COMMITTER_NAME = 'Cosmic Test',
  GIT_COMMITTER_EMAIL = 'test@example.com',
  GIT_CONFIG_GLOBAL = '/dev/null',
}

---@return string stdout
local function git(cwd, ...)
  local args = vim.list_extend({ 'git', '-c', 'init.defaultBranch=main', '-c', 'commit.gpgsign=false' }, { ... })
  local result = vim.system(args, { cwd = cwd, text = true, env = git_env }):wait()
  assert(result.code == 0, ('%s failed: %s'):format(table.concat(args, ' '), result.stderr))
  return vim.trim(result.stdout)
end

local function lockfile(commit)
  return { '{', ('  "p": { "branch": "main", "commit": "%s" }'):format(commit), '}' }
end

--- An upstream CosmicNvim repository, a local install of it, and an isolated lazy.nvim config that
--- manages plugin `p` from the install's lockfile. `p` has two commits and starts at the first.
local function fixture()
  local dir = T.tmpdir()
  local f = { dir = dir, install = dir .. '/install', seed = dir .. '/seed' }

  local plugin = dir .. '/plugin'
  vim.fn.mkdir(plugin, 'p')
  git(plugin, 'init', '-q')
  T.write(plugin .. '/f', { 'v1' })
  git(plugin, 'add', 'f')
  git(plugin, 'commit', '-qm', 'c1')
  f.c1 = git(plugin, 'rev-parse', 'HEAD')
  T.write(plugin .. '/f', { 'v2' })
  git(plugin, 'commit', '-qam', 'c2')
  f.c2 = git(plugin, 'rev-parse', 'HEAD')

  git(dir, 'init', '-q', '--bare', 'up.git')
  git(dir, 'clone', '-q', 'up.git', 'seed')
  T.write(f.seed .. '/lazy-lock.json', lockfile(f.c1))
  T.write(f.seed .. '/README', { 'readme' })
  git(f.seed, 'add', '.')
  git(f.seed, 'commit', '-qm', 'initial')
  git(f.seed, 'push', '-q', 'origin', 'main')
  git(dir, 'clone', '-q', 'up.git', 'install')

  local xdg = dir .. '/xdg'
  T.write(xdg .. '/config/nvim/init.lua', {
    ('vim.opt.rtp:prepend(%q)'):format(vim.fn.stdpath('data') .. '/lazy/lazy.nvim'),
    ("require('lazy').setup({ { url = %q, name = 'p', lazy = false } }, {"):format(plugin),
    "  lockfile = vim.env.COSMICNVIM_INSTALL_DIR .. '/lazy-lock.json',",
    '  change_detection = { enabled = false },',
    '  rocks = { enabled = false },',
    '})',
  })
  f.env = {
    XDG_CONFIG_HOME = xdg .. '/config',
    XDG_DATA_HOME = xdg .. '/data',
    XDG_STATE_HOME = xdg .. '/state',
    XDG_CACHE_HOME = xdg .. '/cache',
    COSMICNVIM_INSTALL_DIR = f.install,
  }
  f.plugin_dir = xdg .. '/data/nvim/lazy/p'

  local result = vim
    .system({ vim.v.progpath, '--headless', '-i', 'NONE', '+Lazy! restore', '+qall!' }, { env = f.env })
    :wait()
  assert(result.code == 0, 'installing the fixture plugin failed')
  T.eq(git(f.plugin_dir, 'rev-parse', 'HEAD'), f.c1, 'fixture plugin starts at c1')
  return f
end

--- Commit to the upstream repository, optionally pinning `p` to a new commit.
local function push(f, commit, message)
  if commit then
    T.write(f.seed .. '/lazy-lock.json', lockfile(commit))
  end
  vim.fn.writefile({ message }, f.seed .. '/README', 'a')
  git(f.seed, 'commit', '-qam', message)
  git(f.seed, 'push', '-q', 'origin', 'main')
end

local function dirty_lockfile(f)
  T.write(f.install .. '/lazy-lock.json', { '{ "local": "changes from :Lazy update" }' })
end

local function lockfile_dirty(f)
  return vim.system({ 'git', 'diff', '--quiet', 'HEAD', '--', 'lazy-lock.json' }, { cwd = f.install }):wait().code == 1
end

local final_messages = {
  'already up to date',
  'CosmicNvim updated:',
  'Plugins restored',
  'restore failed',
  ':Lazy restore',
  'cancelled',
  'Could not',
}

--- Run :CosmicUpdate against the fixture, answering confirm() prompts in order.
---@return string[] prompts, {msg: string, level: integer}[] messages
local function update(env, answers)
  local prompts, messages = {}, {}
  vim.fn.confirm = function(msg)
    table.insert(prompts, msg)
    return table.remove(answers, 1) or 0
  end
  vim.notify = function(msg, level)
    table.insert(messages, { msg = msg, level = level })
  end
  -- The headless restore inherits these, so it runs the fixture's lazy.nvim config.
  for name, value in pairs(env) do
    vim.env[name] = value
  end

  require('cosmic.utils.cosmic').update()
  T.wait(function()
    local last = messages[#messages]
    return last ~= nil
      and vim.iter(final_messages):any(function(pattern)
        return last.msg:find(pattern, 1, true) ~= nil
      end)
  end, 60000, 'CosmicUpdate to finish')
  return prompts, messages
end

local function last_message(messages)
  return messages[#messages]
end

return {
  {
    name = 'reports an up-to-date install and a missing install dir',
    timeout = 120000,
    run = function()
      local f = fixture()
      local _, messages = update(f.env, {})
      T.eq(last_message(messages).msg, 'CosmicNvim is already up to date.')

      _, messages = update(vim.tbl_extend('force', f.env, { COSMICNVIM_INSTALL_DIR = f.dir .. '/missing' }), {})
      T.eq(last_message(messages).level, vim.log.levels.ERROR, 'missing dir level')
      T.truthy(
        last_message(messages).msg:find('Could not fetch CosmicNvim updates', 1, true),
        last_message(messages).msg
      )
    end,
  },
  {
    name = 'asks before discarding local lockfile changes and restores plugins',
    timeout = 120000,
    run = function()
      local f = fixture()
      push(f, f.c2, 'bump p')
      dirty_lockfile(f)
      local before = git(f.install, 'rev-parse', 'HEAD')

      local prompts, messages = update(f.env, { 2 })
      T.eq(#prompts, 1, 'prompt count when cancelling')
      T.truthy(prompts[1]:find('Discard the local lockfile changes', 1, true), prompts[1])
      T.eq(last_message(messages).level, vim.log.levels.WARN, 'cancel level')
      T.eq(git(f.install, 'rev-parse', 'HEAD'), before, 'install not updated after cancelling')
      T.eq(lockfile_dirty(f), true, 'local lockfile changes kept')

      prompts, messages = update(f.env, { 1, 1 })
      T.eq(#prompts, 2, 'prompt count when discarding and restoring')
      T.eq(git(f.install, 'rev-parse', 'HEAD'), git(f.dir .. '/up.git', 'rev-parse', 'main'), 'install updated')
      T.eq(lockfile_dirty(f), false, 'lockfile matches upstream')
      T.eq(git(f.plugin_dir, 'rev-parse', 'HEAD'), f.c2, 'plugin restored to the new lockfile')
      T.truthy(
        vim.iter(messages):any(function(m)
          return m.msg:find('bump p', 1, true) ~= nil
        end),
        'incoming commits listed'
      )
      T.eq(last_message(messages).msg, 'Plugins restored. Restart Neovim to load the changes.')
    end,
  },
  {
    name = 'reports a failed plugin restore and keeps the pulled lockfile',
    timeout = 120000,
    run = function()
      local f = fixture()
      push(f, string.rep('0', 40), 'pin p to a missing commit')
      local _, messages = update(f.env, { 1 })
      T.eq(last_message(messages).level, vim.log.levels.ERROR, 'failure level')
      T.truthy(last_message(messages).msg:find('Failed to restore: p', 1, true), last_message(messages).msg)
      T.eq(lockfile_dirty(f), false, 'pulled lockfile kept')
    end,
  },
  {
    name = 'restoring later and updates that keep the local lockfile',
    timeout = 120000,
    run = function()
      local f = fixture()
      push(f, f.c2, 'bump p')
      local _, messages = update(f.env, { 2 })
      T.truthy(last_message(messages).msg:find(':Lazy restore', 1, true), last_message(messages).msg)
      T.eq(git(f.plugin_dir, 'rev-parse', 'HEAD'), f.c1, 'plugin not restored')

      push(f, nil, 'docs only')
      dirty_lockfile(f)
      local prompts
      prompts, messages = update(f.env, {})
      T.eq(prompts, {}, 'no prompts when upstream leaves the lockfile alone')
      T.eq(git(f.install, 'rev-parse', 'HEAD'), git(f.dir .. '/up.git', 'rev-parse', 'main'), 'install updated')
      T.eq(lockfile_dirty(f), true, 'local lockfile changes kept')
    end,
  },
}
