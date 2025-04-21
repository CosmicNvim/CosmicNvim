-- DEFAULT USER SETTINGS
local ok, user_config = pcall(require, 'cosmic.config.config')

if not ok then
  user_config = {}
end

local default_config = {
  border = 'rounded',
  disable_builtin_plugins = {},
  add_plugins = {},
  lsp = {
    inlay_hint = false,
    format_timeout = 500,
    -- lsp servers that should be enabled
    servers = {
      astro = true,
      cssls = true,
      eslint = true,
      gopls = true,
      html = true,
      jsonls = true,
      lua_ls = true,
      -- Disable in favor of conform ruff
      basedpyright = {
        format_on_save = false
      },
      -- Disable in favor of conform ruff
      ruff = {
        format_on_save = false
      },
      tailwindcss = true,
      vtsls = { format_on_save = false },
    },
  },
}

local u = require('cosmic.utils')
local config = u.merge(default_config, user_config)

return config
