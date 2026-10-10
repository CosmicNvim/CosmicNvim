local T = require('tests.harness')

-- basedpyright runs as an in-process fake; ruff is not installed in the test environment.
local config = { lsp = { servers = { basedpyright = { mason = false, cmd = T.fake_server({}) }, ruff = false } } }

---@param path string
local function make_executable(path)
  T.write(path, { '#!/bin/sh' })
  vim.uv.fs_chmod(path, 493) -- 0755
end

--- A Poetry project with an environment outside the project, like Poetry's default.
---@return string root, string env
local function poetry_project()
  local root = T.tmpdir()
  T.write(root .. '/pyproject.toml', { '[project]', 'name = "demo"' })
  T.write(root .. '/poetry.lock', { '# lockfile' })
  T.write(root .. '/main.py', { 'print(1)' })
  T.write(root .. '/other.py', { 'print(2)' })
  local env = T.tmpdir()
  make_executable(env .. '/bin/python')
  return root, env
end

--- Put a fake `poetry` on PATH. `poetry env info -p` sleeps, then prints `env` or fails when it is nil.
---@param env? string
---@param delay number seconds
---@return fun(): integer runs
local function fake_poetry(env, delay)
  local bin = T.tmpdir()
  local runs = bin .. '/runs'
  T.write(bin .. '/poetry', {
    '#!/bin/sh',
    ("echo run >> '%s'"):format(runs),
    ('sleep %s'):format(delay),
    env and ("echo '%s'"):format(env) or 'exit 1',
  })
  vim.uv.fs_chmod(bin .. '/poetry', 493)
  vim.env.PATH = bin .. ':' .. vim.env.PATH
  return function()
    return vim.fn.filereadable(runs) == 1 and #vim.fn.readfile(runs) or 0
  end
end

---@return vim.lsp.Client
local function wait_for_basedpyright()
  local client
  T.wait(function()
    client = vim.lsp.get_clients({ name = 'basedpyright', bufnr = 0 })[1]
    return client ~= nil and client.initialized
  end, 10000, 'basedpyright to start')
  return client
end

return {
  {
    name = 'Poetry projects use their environment without blocking the editor',
    config = config,
    run = function()
      local root, env = poetry_project()
      local runs = fake_poetry(env, 2)

      local started = vim.uv.hrtime()
      vim.cmd.edit(root .. '/main.py')
      local blocked_ms = (vim.uv.hrtime() - started) / 1e6
      T.truthy(blocked_ms < 1000, ('opening the file blocked for %dms'):format(blocked_ms))

      local client = wait_for_basedpyright()
      T.eq(client.settings.python.pythonPath, env .. '/bin/python', 'pythonPath')
      T.eq(vim.uv.fs_realpath(client.root_dir), vim.uv.fs_realpath(root), 'root_dir')
      T.eq(runs(), 1, 'poetry runs')
    end,
  },
  {
    name = 'files opened while Poetry is running share one lookup and one server',
    config = config,
    run = function()
      local root, env = poetry_project()
      local runs = fake_poetry(env, 1)
      vim.cmd.edit(root .. '/main.py')
      local first = vim.api.nvim_get_current_buf()
      vim.cmd.edit(root .. '/other.py')
      local client = wait_for_basedpyright()
      T.wait(function()
        return vim.lsp.buf_is_attached(first, client.id)
      end, 5000, 'basedpyright to attach to the first file')
      T.eq(#vim.lsp.get_clients({ name = 'basedpyright' }), 1, 'basedpyright clients')
      T.eq(runs(), 1, 'poetry runs')
    end,
  },
  {
    name = 'Poetry projects without an environment fall back to python3',
    config = config,
    run = function()
      local root = poetry_project()
      fake_poetry(nil, 0)
      vim.cmd.edit(root .. '/main.py')
      T.eq(wait_for_basedpyright().settings.python.pythonPath, vim.fn.exepath('python3'))
    end,
  },
  {
    name = 'an activated virtualenv takes precedence over Poetry',
    config = config,
    run = function()
      local root = poetry_project()
      local runs = fake_poetry(T.tmpdir(), 0)
      local venv = T.tmpdir()
      make_executable(venv .. '/bin/python')
      vim.env.VIRTUAL_ENV = venv
      vim.cmd.edit(root .. '/main.py')
      T.eq(wait_for_basedpyright().settings.python.pythonPath, venv .. '/bin/python', 'pythonPath')
      T.eq(runs(), 0, 'poetry runs')
    end,
  },
  {
    name = 'a project .venv is used even when it is not activated',
    run = function()
      local root = T.tmpdir()
      local python = root .. '/.venv/bin/python'
      make_executable(python)
      local server = vim.deepcopy(vim.lsp.config.basedpyright)
      server.root_dir = root
      server.before_init({}, server)
      T.eq(server.settings.python.pythonPath, python, 'pythonPath')
    end,
  },
}
