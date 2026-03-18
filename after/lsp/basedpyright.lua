local python_path_cache = {}

local function get_poetry_python(executable_name, root_dir)
  if vim.fn.executable('poetry') == 0 then
    return nil
  end

  local search_from = root_dir or vim.uv.cwd()
  local poetry_lock = vim.fs.find('poetry.lock', {
    upward = true,
    type = 'file',
    path = search_from,
  })[1]
  if not poetry_lock then
    return nil
  end

  local project_dir = vim.fs.dirname(poetry_lock)
  local result = vim.system({ 'poetry', 'env', 'info', '-p' }, { cwd = project_dir, text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local env_path = vim.trim(result.stdout or '')
  if env_path == '' then
    return nil
  end

  local poetry_python = vim.fs.joinpath(env_path, 'bin', executable_name)
  if vim.fn.executable(poetry_python) == 1 then
    return poetry_python
  end

  return nil
end

local function resolve_python_path(root_dir)
  local cache_key = root_dir or vim.uv.cwd()
  if cache_key and python_path_cache[cache_key] then
    return python_path_cache[cache_key]
  end

  local resolved_python = nil

  if vim.env.VIRTUAL_ENV then
    local venv_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
    if vim.fn.executable(venv_python) == 1 then
      resolved_python = venv_python
    end
  end

  if not resolved_python then
    local poetry_python = get_poetry_python('python', root_dir)
    if poetry_python then
      resolved_python = poetry_python
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
  if cache_key then
    python_path_cache[cache_key] = resolved_python
  end

  return resolved_python
end

local function set_python_path(config, root_dir)
  config.settings = config.settings or {}
  config.settings.python = config.settings.python or {}
  config.settings.python.pythonPath = resolve_python_path(root_dir)
end

---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  before_init = function(_, config)
    set_python_path(config, config.root_dir)
  end,
  on_new_config = function(new_config, root_dir)
    set_python_path(new_config, root_dir)
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
