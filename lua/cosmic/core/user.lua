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
    format_on_save = true, -- true/false or table of filetypes {'.ts', '.js',}
    format_timeout = 500,
    rename_notification = true,
    -- table of callbacks pushed via plugins
    on_attach_mappings = {},
    -- lsp servers that should be installed
    ensure_installed = {
      'astro',
      'eslint',
      'prettierd',
      'cssls',
      'gopls',
      'graphql',
      'html',
      'jsonls',
      'tsserver',
      'lua_ls',
      'pyright',
      'svelte',
      'tailwindcss',
      'yamlls',
    },
    -- lsp servers that should be enabled
    servers = {
      astro = true,
      tailwindcss = true,
      eslint = true,
      jsonls = {
        format = false,
      },
      pyright = true,
      lua_ls = {
        format = false,
      },
      gopls = true,
      html = true,
      tsserver = {
        format = false,
      },
    },
  },
}

local u = require('cosmic.utils')
local config = u.merge(default_config, user_config)

function config.lsp.add_on_attach_mapping(callback)
  table.insert(config.lsp.on_attach_mappings, callback)
end

return config
