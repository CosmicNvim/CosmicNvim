-- Test harness for `nvim -l tests/run.lua`.
--
-- Every test case runs in its own headless Neovim that starts the full Cosmic config from an isolated
-- `.tests/` environment: plugins come from lazy-lock.json and never touch the developer's own setup.
-- Spec files in tests/spec/ return a list of cases:
--
--   {
--     name = 'what the case checks',
--     config = { ... } | function() ... end, -- lua/cosmic/config/config.lua contents (default: {})
--     editor = function() ... end,           -- lua/cosmic/config/editor.lua contents
--     run = function() ... end,              -- runs after startup; raise an error to fail
--     timeout = 60000,
--   }
local M = {}

M.root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
M.env_dir = M.root .. '/.tests'

local result_marker = '__COSMIC_TEST_RESULT__'

--- Environment for child Neovims: isolated XDG dirs with this repository as the config.
---@return table<string, string>
function M.child_env()
  local env = vim.fn.environ()
  -- Drop settings that would point Cosmic at the developer's own environment.
  for _, name in ipairs({ 'NVIM', 'NVIM_APPNAME', 'VIRTUAL_ENV', 'VIMINIT', 'MYVIMRC' }) do
    env[name] = nil
  end
  env.XDG_CONFIG_HOME = M.env_dir .. '/config'
  env.XDG_DATA_HOME = M.env_dir .. '/data'
  env.XDG_STATE_HOME = M.env_dir .. '/state'
  env.XDG_CACHE_HOME = M.env_dir .. '/cache'
  -- lazy.nvim rewrites the lockfile after installs, so give it a copy instead of the repository's file.
  env.COSMICNVIM_INSTALL_DIR = M.env_dir .. '/install'
  return env
end

---@param spec_file? string
---@param index? integer
---@return string[]
local function child_args(spec_file, index)
  local before = ('lua package.path = %q .. package.path; require("tests.harness").before_startup(%s, %s)'):format(
    M.root .. '/?.lua;',
    spec_file and ('%q'):format(spec_file) or 'nil',
    index or 'nil'
  )
  return { vim.v.progpath, '--headless', '-i', 'NONE', '--cmd', before }
end

---@param path string
---@return string|nil
local function read(path)
  local file = io.open(path, 'rb')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

---@param path string
---@param content string
local function write_file(path, content)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  local file = assert(io.open(path, 'wb'))
  file:write(content)
  file:close()
end

--- Create the isolated environment and refresh its lockfile copy.
function M.setup()
  vim.fn.mkdir(M.env_dir .. '/config', 'p')
  local link = M.env_dir .. '/config/nvim'
  if not vim.uv.fs_lstat(link) then
    assert(vim.uv.fs_symlink(M.root, link))
  end
  write_file(M.env_dir .. '/install/lazy-lock.json', assert(read(M.root .. '/lazy-lock.json')))
end

--- Install plugins at the lockfile revisions. Skipped when nothing changed since the last run.
function M.bootstrap()
  local lockfile = assert(read(M.root .. '/lazy-lock.json'))
  local stamp = M.env_dir .. '/bootstrap.stamp'
  if read(stamp) == lockfile then
    return
  end

  print('Installing plugins into .tests/ ...')
  local args = vim.list_extend(child_args(), { '+Lazy! restore', '+qall!' })
  local result = vim.system(args, { env = M.child_env(), clear_env = true, text = true, cwd = M.env_dir }):wait()
  if result.code ~= 0 then
    error(('Plugin install failed (exit code %d):\n%s%s'):format(result.code, result.stdout, result.stderr))
  end

  local missing = {}
  for name, entry in pairs(vim.json.decode(lockfile)) do
    local dir = M.env_dir .. '/data/nvim/lazy/' .. name
    local head = vim.uv.fs_stat(dir) and vim.system({ 'git', 'rev-parse', 'HEAD' }, { cwd = dir, text = true }):wait()
    if not head or vim.trim(head.stdout) ~= entry.commit then
      table.insert(missing, name)
    end
  end
  if #missing > 0 then
    table.sort(missing)
    error('Plugins not at their lockfile revisions: ' .. table.concat(missing, ', ') .. '\n' .. result.stdout)
  end
  write_file(stamp, lockfile)
end

--- Run one case in a child Neovim.
---@param spec_file string
---@param index integer
---@param case table
---@return boolean ok, string|nil err
function M.run_child(spec_file, index, case)
  local args = vim.list_extend(child_args(spec_file, index), { '-c', 'lua require("tests.harness").run_case()' })
  local result = vim
    .system(args, {
      env = M.child_env(),
      clear_env = true,
      text = true,
      cwd = M.env_dir,
      timeout = case.timeout or 60000,
    })
    :wait()

  local stderr = vim.trim(result.stderr or '')
  local payload = (result.stdout or ''):match(result_marker .. '([^\n]*)')
  if not payload then
    local reason = result.code == 124 and 'timed out' or ('exited with code %d'):format(result.code)
    return false, ('Neovim %s before the case finished.\n%s'):format(reason, stderr)
  end

  local outcome = vim.json.decode(payload)
  if not outcome.ok then
    return false, outcome.err .. (stderr ~= '' and ('\nstderr:\n' .. stderr) or '')
  end
  -- Startup or runtime errors that did not fail an assertion still fail the case.
  if stderr:find('E%d+:') or stderr:find('[Ee]rror') or stderr:find('stack traceback') then
    return false, 'Unexpected errors on stderr:\n' .. stderr
  end
  return true
end

-- Child side ----------------------------------------------------------------------------------------

--- Runs from `--cmd` in the child, before Cosmic loads.
---@param spec_file? string
---@param index? integer
function M.before_startup(spec_file, index)
  local case = spec_file and dofile(spec_file)[index] or { run = function() end }
  M.case = case

  -- Never load the developer's own lua/cosmic/config files.
  package.preload['cosmic.config.config'] = type(case.config) == 'function' and case.config
    or function()
      return case.config or {}
    end
  package.preload['cosmic.config.editor'] = case.editor or function() end

  -- Record Mason installs instead of downloading language servers.
  package.preload['mason-lspconfig'] = function()
    return {
      setup = function(opts)
        M.mason_lspconfig_opts = opts
      end,
    }
  end

  -- Skip parser downloads; cases use the parsers bundled with Neovim.
  package.preload['nvim-treesitter.install'] = function()
    local noop = function() end
    return { install = noop, update = noop, uninstall = noop }
  end
end

--- Runs from `-c` in the child, after Cosmic has started.
function M.run_case()
  local ok, err = xpcall(M.case.run, debug.traceback)
  io.stdout:write(
    ('\n%s%s\n'):format(result_marker, vim.json.encode({ ok = ok, err = not ok and tostring(err) or nil }))
  )
  io.stdout:flush()
  vim.cmd('qall!')
end

-- Helpers for cases ----------------------------------------------------------------------------------

---@param actual any
---@param expected any
---@param label? string
function M.eq(actual, expected, label)
  if not vim.deep_equal(actual, expected) then
    error(
      ('%s\nexpected: %s\n  actual: %s'):format(label or 'values differ', vim.inspect(expected), vim.inspect(actual)),
      2
    )
  end
end

---@param value any
---@param label? string
function M.truthy(value, label)
  if not value then
    error(('%s: expected a truthy value, got %s'):format(label or 'assertion failed', vim.inspect(value)), 2)
  end
end

---@param predicate fun(): boolean
---@param timeout? integer
---@param label? string
function M.wait(predicate, timeout, label)
  if not vim.wait(timeout or 10000, predicate, 50) then
    error('timed out waiting for ' .. (label or 'condition'), 2)
  end
end

--- Capture vim.notify calls, including notifications Cosmic scheduled during startup.
---@return {msg: string, level: integer}[]
function M.capture_notifications()
  local notes = {}
  vim.notify = function(msg, level)
    table.insert(notes, { msg = msg, level = level })
  end
  vim.wait(100)
  return notes
end

---@return string
function M.tmpdir()
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, 'p')
  return dir
end

---@param path string
---@param lines string[]
function M.write(path, lines)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(lines, path)
end

--- An in-process language server for Cosmic's LSP integration, usable as `cmd`.
---@param opts {formatting?: boolean, inlay_hints?: boolean}
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
function M.fake_server(opts)
  local capabilities = {
    documentFormattingProvider = opts.formatting or nil,
    inlayHintProvider = opts.inlay_hints or nil,
  }
  local handlers = {
    initialize = function()
      return { capabilities = capabilities }
    end,
    ['textDocument/formatting'] = function(params)
      local lines = vim.api.nvim_buf_line_count(vim.uri_to_bufnr(params.textDocument.uri))
      return {
        {
          range = { start = { line = 0, character = 0 }, ['end'] = { line = lines, character = 0 } },
          newText = 'formatted\n',
        },
      }
    end,
    ['textDocument/inlayHint'] = function()
      return {}
    end,
  }

  return function(dispatchers)
    local closing = false
    local request_id = 0
    return {
      request = function(method, params, callback)
        request_id = request_id + 1
        local handler = handlers[method]
        vim.schedule(function()
          callback(nil, handler and handler(params) or vim.NIL)
        end)
        return true, request_id
      end,
      notify = function(method)
        if method == 'exit' then
          dispatchers.on_exit(0, 15)
        end
        return true
      end,
      is_closing = function()
        return closing
      end,
      terminate = function()
        closing = true
      end,
    }
  end
end

--- `lsp.servers.cosmic_fake` settings that enable the fake server for `*.cosmictest` files.
---@param opts {formatting?: boolean, inlay_hints?: boolean}
---@param overrides? table
---@return table
function M.fake_server_config(opts, overrides)
  return vim.tbl_extend('force', {
    mason = false,
    cmd = M.fake_server(opts),
    filetypes = { 'cosmictest' },
  }, overrides or {})
end

--- Open a `*.cosmictest` file and wait for the fake server to attach.
---@param path string
---@param lines? string[]
---@return integer bufnr
function M.open_with_fake_server(path, lines)
  vim.filetype.add({ extension = { cosmictest = 'cosmictest' } })
  M.write(path, lines or { 'raw' })
  vim.cmd.edit(path)
  local bufnr = vim.api.nvim_get_current_buf()
  M.wait(function()
    local client = vim.lsp.get_clients({ name = 'cosmic_fake', bufnr = bufnr })[1]
    return client ~= nil and client.initialized
  end, 10000, 'the fake server to attach')
  return bufnr
end

return M
