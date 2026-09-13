local M = {}

local function check_tool(name, purpose, required)
  if vim.fn.executable(name) == 1 then
    vim.health.ok(name .. ': ' .. purpose)
  else
    local report = required and vim.health.error or vim.health.warn
    report(name .. ' not found in PATH: ' .. purpose)
  end
end

-- Inspect already-loaded values only: requiring user config can execute arbitrary code.
local function validate_config(config)
  local errors = {}
  local function expect(value, kind, field)
    if value ~= nil and type(value) ~= kind then
      errors[#errors + 1] = field .. ' must be a ' .. kind
      return false
    end
    return true
  end

  if not expect(config, 'table', 'config.lua return value') then
    return errors
  end
  expect(config.diagnostics, 'table', 'diagnostics')
  if expect(config.plugins, 'table', 'plugins') and config.plugins and not vim.islist(config.plugins) then
    errors[#errors + 1] = 'plugins must be a list of lazy.nvim specs'
  end
  if expect(config.lsp, 'table', 'lsp') and config.lsp then
    local lsp = config.lsp
    expect(lsp.format_timeout, 'number', 'lsp.format_timeout')
    expect(lsp.inlay_hint, 'boolean', 'lsp.inlay_hint')
    if expect(lsp.servers, 'table', 'lsp.servers') and lsp.servers then
      for name, server in pairs(lsp.servers) do
        local field = 'lsp.servers.' .. tostring(name)
        if type(name) ~= 'string' or (type(server) ~= 'boolean' and type(server) ~= 'table') then
          errors[#errors + 1] = field .. ' must have a string name and a boolean or table value'
        elseif type(server) == 'table' then
          if server.opts ~= nil then
            errors[#errors + 1] = field .. '.opts is unsupported; put LSP fields directly under ' .. field
          end
          for _, flag in ipairs({ 'format_on_save', 'formatting', 'mason' }) do
            expect(server[flag], 'boolean', field .. '.' .. flag)
          end
        end
      end
    end
  end
  return errors
end

function M.check()
  vim.health.start('CosmicNvim runtime')
  if vim.fn.has('nvim-0.13') == 1 then
    vim.health.ok('Neovim 0.13+ is available')
  else
    vim.health.error('CosmicNvim requires Neovim 0.13+; install a compatible nightly build.')
  end
  check_tool('git', 'required for lazy.nvim bootstrap and plugin updates', true)

  vim.health.start('Optional tools')
  vim.health.info(
    'Missing tools below affect specific features, not core startup. Project-local tools may not be in PATH.'
  )
  for _, tool in ipairs({
    { 'rg', 'ripgrep for picker text searches' },
    { 'fd', 'faster picker file searches; other file-finder backends may be available' },
    { 'node', 'Node.js for JavaScript/TypeScript language tools' },
    { 'tree-sitter', 'Tree-sitter CLI for parser installation' },
    { 'curl', 'downloads used by parser/package installers' },
    { 'tar', 'archive extraction used by parser/package installers' },
    { 'oxfmt', 'default web/JSON/Markdown formatting' },
    { 'oxlint', 'default JavaScript/TypeScript lint fixes' },
    { 'eslint_d', 'default JavaScript/TypeScript ESLint fixes' },
    { 'stylua', 'default Lua formatting' },
    { 'ruff', 'default Python fixes, formatting and import organization' },
    { 'goimports', 'default Go import formatting' },
    { 'gofmt', 'default Go formatting' },
  }) do
    check_tool(tool[1], tool[2], false)
  end
  if vim.fn.executable('cc') == 1 or vim.fn.executable('gcc') == 1 or vim.fn.executable('clang') == 1 then
    vim.health.ok('C compiler available for Tree-sitter parsers')
  else
    vim.health.warn('No cc, gcc or clang in PATH; Tree-sitter parser installation needs a C compiler.')
  end
  vim.health.info('Use :checkhealth lazy, :checkhealth mason and :ConformInfo for plugin-specific diagnostics.')

  vim.health.start('User configuration')
  local install_dir = vim.env.COSMICNVIM_INSTALL_DIR or vim.fn.stdpath('config')
  local config_dir = install_dir .. '/lua/cosmic/config/'
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
  local config = package.loaded['cosmic.config.config']
  if config ~= nil then
    local ok, errors = pcall(validate_config, config)
    if not ok then
      vim.health.error('Cannot inspect loaded user configuration: ' .. tostring(errors))
    elseif #errors == 0 then
      vim.health.ok('Loaded user configuration passes basic schema checks')
    else
      for _, err in ipairs(errors) do
        vim.health.error(err)
      end
    end
  else
    vim.health.info('User config is not loaded; only syntax was checked. No user code or plugins were executed.')
  end
end

return M
