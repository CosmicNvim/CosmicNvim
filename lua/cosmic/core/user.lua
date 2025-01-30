-- DEFAULT USER SETTINGS
local ok, user_config = pcall(require, 'cosmic.config.config')

if not ok then
  user_config = {}
end

local default_config = {
  border = 'rounded',
  disable_builtin_plugins = {},
  add_plugins = {},
  plugins = {},
  lsp = {
    inlay_hint = false,
    format_timeout = 500,
    rename_notification = true,
    -- table of callbacks pushed via plugins
    on_attach_mappings = {},
    -- lsp servers that should be installed
    ensure_installed = {
      'astro',
      'cssls',
      'eslint',
      'gopls',
      'html',
      'jsonls',
      'lua_ls',
      'prettierd',
      'pyright',
      'tailwindcss',
      'vtsls',
    },
    -- lsp servers that should be enabled
    servers = {
      astro = true,
      cssls = true,
      eslint = true,
      gopls = true,
      html = true,
      jsonls = true,
      lua_ls = true,
      pyright = true,
      tailwindcss = true,
      vtsls = { format_on_save = false },
    },
  },
}

local u = require('cosmic.utils')
local config = u.merge(default_config, user_config)

function config.lsp.add_on_attach_mapping(callback)
  table.insert(config.lsp.on_attach_mappings, callback)
end

return config
