local function get_poetry_python(executable_name)
  if vim.fn.executable('poetry') == 0 then
    return nil
  end

  local poetry_lock = vim.fs.find('poetry.lock', { upward = true, type = 'file' })[1]
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

local function resolve_python_path()
  if vim.env.VIRTUAL_ENV then
    local venv_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
    if vim.fn.executable(venv_python) == 1 then
      return venv_python
    end
  end

  local poetry_python = get_poetry_python('python')
  if poetry_python then
    return poetry_python
  end

  local python3 = vim.fn.exepath('python3')
  if python3 ~= '' then
    return python3
  end

  local python = vim.fn.exepath('python')
  if python ~= '' then
    return python
  end

  return 'python'
end

---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
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
    python = {
      pythonPath = resolve_python_path(),
    },
  },
}
