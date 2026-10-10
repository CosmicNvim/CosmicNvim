-- Interpreter per project root, resolved once per session.
local python_path_cache = {}
-- Poetry environment interpreter per Poetry project; false when Poetry reports none.
local poetry_python_cache = {}
-- Callbacks waiting for an in-flight `poetry env info` per Poetry project.
local poetry_pending = {}

---@param root_dir? string
---@return string|nil
local function find_local_python(root_dir)
  if vim.env.VIRTUAL_ENV then
    local venv_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  -- Project-local environments, such as uv's default .venv, are often not activated in the shell.
  if root_dir then
    for _, venv in ipairs({ '.venv', 'venv' }) do
      local venv_python = vim.fs.joinpath(root_dir, venv, 'bin', 'python')
      if vim.fn.executable(venv_python) == 1 then
        return venv_python
      end
    end
  end
end

---@param root_dir? string
---@return string|nil project_dir
local function find_poetry_project(root_dir)
  if vim.fn.executable('poetry') == 0 then
    return nil
  end

  local poetry_lock = vim.fs.find('poetry.lock', {
    upward = true,
    type = 'file',
    path = root_dir or vim.uv.cwd(),
  })[1]
  return poetry_lock and vim.fs.dirname(poetry_lock)
end

---@param result vim.SystemCompleted
---@return string|false
local function parse_poetry_python(result)
  local env_path = result.code == 0 and vim.trim(result.stdout or '') or ''
  local poetry_python = env_path ~= '' and vim.fs.joinpath(env_path, 'bin', 'python')
  return poetry_python and vim.fn.executable(poetry_python) == 1 and poetry_python or false
end

--- Look up a Poetry project's environment without blocking the editor.
---@param project_dir string
---@param callback fun()
local function lookup_poetry_python(project_dir, callback)
  if poetry_python_cache[project_dir] ~= nil then
    return callback()
  end
  if poetry_pending[project_dir] then
    table.insert(poetry_pending[project_dir], callback)
    return
  end

  poetry_pending[project_dir] = { callback }
  local function finish(result)
    poetry_python_cache[project_dir] = parse_poetry_python(result)
    local callbacks = poetry_pending[project_dir]
    poetry_pending[project_dir] = nil
    for _, pending in ipairs(callbacks) do
      pending()
    end
  end

  local ok = pcall(
    vim.system,
    { 'poetry', 'env', 'info', '-p' },
    { cwd = project_dir, text = true },
    vim.schedule_wrap(finish)
  )
  if not ok then
    finish({ code = -1 })
  end
end

---@param root_dir? string
---@return string
local function resolve_python_path(root_dir)
  local cache_key = root_dir or vim.uv.cwd()
  if python_path_cache[cache_key] then
    return python_path_cache[cache_key]
  end

  local resolved_python = find_local_python(root_dir)

  if not resolved_python then
    local project_dir = find_poetry_project(root_dir)
    if project_dir then
      -- root_dir normally resolves this before the server starts; this only blocks if root_dir was overridden.
      if poetry_python_cache[project_dir] == nil then
        local result = vim.system({ 'poetry', 'env', 'info', '-p' }, { cwd = project_dir, text = true }):wait()
        poetry_python_cache[project_dir] = parse_poetry_python(result)
      end
      resolved_python = poetry_python_cache[project_dir] or nil
    end
  end

  if not resolved_python then
    local python3 = vim.fn.exepath('python3')
    if python3 ~= '' then
      resolved_python = python3
    end
  end

  if not resolved_python then
    local python = vim.fn.exepath('python')
    if python ~= '' then
      resolved_python = python
    end
  end

  resolved_python = resolved_python or 'python'
  python_path_cache[cache_key] = resolved_python
  return resolved_python
end

---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  -- Same project root as nvim-lspconfig's root_markers, but the server only starts once a Poetry
  -- environment lookup has finished, so `poetry env info` never blocks the editor.
  root_dir = function(bufnr, on_dir)
    local server = vim.lsp.config.basedpyright
    local root = vim.fs.root(bufnr, server.root_markers or { '.git' })
    local project_dir = not vim.tbl_get(server, 'settings', 'python', 'pythonPath')
      and not python_path_cache[root or vim.uv.cwd()]
      and not find_local_python(root)
      and find_poetry_project(root)
    if not project_dir then
      return on_dir(root)
    end

    lookup_poetry_python(project_dir, function()
      -- Don't start a server for a buffer that was closed while Poetry was answering.
      if vim.api.nvim_buf_is_loaded(bufnr) then
        on_dir(root)
      end
    end)
  end,
  before_init = function(_, config)
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    -- Keep a pythonPath set in lsp.servers.basedpyright.settings.
    config.settings.python.pythonPath = config.settings.python.pythonPath or resolve_python_path(config.root_dir)
  end,
  settings = {
    basedpyright = {
      analysis = {
        --[[ diagnosticMode = 'workspace', ]]
        --[[ typeCheckingMode = "basic", ]]
        --[[ useLibraryCodeForTypes = true, ]]
        ignore = { '*' },
      },
      disableOrganizeImports = true,
    },
    python = {},
  },
}
