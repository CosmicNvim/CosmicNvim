-- FIXED but credit: https://github.com/jack-michaud/nvim/blob/33aefa8055aedc8d0dd592292aba903d9fb9ee2d/lua/plugins/editor.lua#L1
local function prefer_bin_from_venv(executable_name)
  -- Return the path to the executable if $VIRTUAL_ENV is set and the binary exists somewhere beneath the $VIRTUAL_ENV path, otherwise get it from Mason
  if vim.env.VIRTUAL_ENV then
    local paths = vim.fn.glob(vim.env.VIRTUAL_ENV .. '/**/bin/' .. executable_name, true, true)
    local executable_path = table.concat(paths, ', ')
    if executable_path ~= '' then
      --vim.api.nvim_echo({ { "Using path for " .. executable_name .. ": " .. executable_path, "None" } }, false, {})
      return executable_path
    end
  end

  -- find poetry.lock file in current directory or parent directories
  local poetry_lock = vim.fn.findfile('poetry.lock', '.;')
  if poetry_lock ~= '' then
    -- use `poetry env info -p -C <path of folder containing poetry.lock>` to get the virtualenv path
    local poetry_env_path =
        vim.fn.systemlist('poetry env list --full-path -C ' .. vim.fn.fnamemodify(poetry_lock, ':h'))

    if #poetry_env_path > 0 then
      local candidate_paths = {}
      for _, env_path in ipairs(poetry_env_path) do
        if env_path ~= '' then
          if string.sub(env_path, 0, 1) == '/' then
            table.insert(candidate_paths, 0, env_path)
          end
        end
      end
      local selected_poetry_env_path = candidate_paths[0]
      if #poetry_env_path > 0 then
        for _, env_path in ipairs(poetry_env_path) do
          if string.find(env_path, 'Activated') then
            -- Must strip the word "(Activated)" from the string

            selected_poetry_env_path = string.gsub(env_path, ' %(Activated%)', '')
            selected_poetry_env_path = vim.fn.trim(selected_poetry_env_path)
            break
          end
        end
      end
      local venv_path_to_python = selected_poetry_env_path .. '/bin/' .. executable_name
      if vim.fn.filereadable(venv_path_to_python) == 1 then
        return venv_path_to_python
      end
    end
  end

  local mason_registry = require('mason-registry')
  if mason_registry.has_package(executable_name) == false then
    return executable_name
  end
  local mason_path = mason_registry.get_package(executable_name):get_install_path() .. '/venv/bin/' .. executable_name
  return mason_path
end

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
      pythonPath = prefer_bin_from_venv('python'),
    }
  }
}
