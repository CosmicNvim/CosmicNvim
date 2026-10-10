local M = {}

---@param names string|string[] executable name, or alternative names for the same tool
---@param purpose string
---@param required boolean
local function check_tool(names, purpose, required)
  names = type(names) == 'table' and names or { names }
  for _, name in ipairs(names) do
    if vim.fn.executable(name) == 1 then
      vim.health.ok(name .. ': ' .. purpose)
      return
    end
  end
  local report = required and vim.health.error or vim.health.warn
  report(table.concat(names, ' or ') .. ' not found in PATH: ' .. purpose)
end

function M.check()
  vim.health.start('CosmicNvim runtime')
  if vim.fn.has('nvim-0.13') == 1 then
    vim.health.ok('Neovim 0.13+ is available')
  else
    vim.health.error('CosmicNvim requires Neovim 0.13+; install a compatible nightly build.')
  end
  check_tool('git', 'required for lazy.nvim bootstrap and plugin updates', true)

  -- Installs that link individual files into ~/.config/nvim can miss Cosmic's after/ directory.
  -- Match Cosmic's own directory: plugins such as mason-lspconfig ship after/lsp/ files too.
  local after_lsp = vim.uv.fs_realpath(vim.fn.stdpath('config') .. '/after/lsp')
  local after_loaded = after_lsp ~= nil
    and vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true)):any(function(path)
      return vim.uv.fs_realpath(vim.fs.dirname(path)) == after_lsp
    end)
  if after_loaded then
    vim.health.ok("Cosmic's after/lsp/ server settings are on the runtimepath")
  else
    vim.health.warn(
      "Cosmic's after/lsp/ server settings are not on the runtimepath, so they won't load.",
      ('If %s links individual files from CosmicNvim, link its after/ directory too.'):format(vim.fn.stdpath('config'))
    )
  end

  local install_dir = require('cosmic.utils.cosmic').get_install_dir()
  local toplevel = vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { cwd = install_dir, text = true }):wait()
  local advice = 'Set COSMICNVIM_INSTALL_DIR to the CosmicNvim git checkout.'
  if toplevel.code ~= 0 then
    vim.health.warn(install_dir .. ' is not a git checkout, so :CosmicUpdate cannot update CosmicNvim.', advice)
  elseif vim.uv.fs_realpath(vim.trim(toplevel.stdout)) ~= vim.uv.fs_realpath(install_dir) then
    vim.health.warn(
      ('%s is inside the git repository %s, so :CosmicUpdate would update that repository.'):format(
        install_dir,
        vim.trim(toplevel.stdout)
      ),
      advice
    )
  else
    vim.health.ok(':CosmicUpdate updates the git checkout in ' .. install_dir)
  end

  vim.health.start('Optional tools')
  vim.health.info(
    'Missing tools below affect specific features, not core startup. Project-local tools may not be in PATH.'
  )
  for _, tool in ipairs({
    { 'rg', 'ripgrep for picker text searches' },
    { { 'fd', 'fdfind' }, 'fd 8.4+ is required to search in the file explorer (<leader>e) and speeds up file pickers' },
    { 'node', 'Node.js for JavaScript/TypeScript language tools' },
    { 'tree-sitter', 'Tree-sitter CLI for parser installation' },
    { 'curl', 'downloads used by parser/package installers' },
    { 'tar', 'archive extraction used by parser/package installers' },
    { 'oxfmt', 'default web/JSON/Markdown formatting' },
    { 'oxlint', 'default JavaScript/TypeScript lint fixes' },
    { 'stylua', 'default Lua formatting' },
    { 'ruff', 'default Python fixes, formatting and import organization' },
    { 'goimports', 'default Go import formatting' },
    { 'gofmt', 'default Go formatting' },
  }) do
    check_tool(tool[1], tool[2], false)
  end
  if vim.fn.executable('cc') == 1 or vim.fn.executable('gcc') == 1 or vim.fn.executable('clang') == 1 then
    vim.health.ok('C compiler available for Tree-sitter parsers and LuaSnip jsregexp')
  else
    vim.health.warn(
      'No cc, gcc or clang in PATH; Tree-sitter parser installation and LuaSnip jsregexp need a C compiler.'
    )
  end
  check_tool('make', 'builds LuaSnip jsregexp for snippet regex transformations', false)
  vim.health.info('Use :checkhealth lazy, :checkhealth mason and :ConformInfo for plugin-specific diagnostics.')

  vim.health.start('User configuration')
  local config_dir = require('cosmic.utils.cosmic').get_install_dir() .. '/lua/cosmic/config/'
  for _, name in ipairs({ 'config', 'editor' }) do
    local path = config_dir .. name .. '.lua'
    if vim.uv.fs_stat(path) then
      local chunk, err = loadfile(path)
      if chunk then
        vim.health.ok(path .. ' parses successfully')
      else
        vim.health.error(tostring(err))
      end
    else
      vim.health.info(path .. ' is absent; this override is optional')
    end
  end
  -- Report what Cosmic found when it loaded config.lua at startup, without running user code again.
  local user_config = package.loaded['cosmic.core.user']
  if user_config == nil then
    vim.health.info('Cosmic has not loaded the user configuration; only syntax was checked.')
  elseif user_config.load_error then
    vim.health.error(user_config.load_error, 'Cosmic is using default settings until config.lua is fixed.')
  else
    vim.health.ok('User configuration loaded without errors')
  end
end

return M
