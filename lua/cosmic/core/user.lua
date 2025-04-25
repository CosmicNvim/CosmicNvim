-- DEFAULT USER SETTINGS
local ok, user_config = pcall(require, 'cosmic.config.config')

if not ok then
  user_config = {}
end

--- @class CosmicUserConfigLspSever
--- @field format_on_save? boolean
--- @field opts? vim.lsp.ClientConfig

--- @class CosmicUserConfigLsp
--- @field format_timeout number
--- @field inlay_hint boolean
--- @field servers table<string, CosmicUserConfigLspSever|boolean>

--- @class CosmicUserConfig
--- @field add_plugins LazySpec[]
--- @field diagnostics? vim.diagnostic.Opts
--- @field disable_builtin_plugins string[]
--- @field lsp CosmicUserConfigLsp

--- @type CosmicUserConfig
local default_config = {
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

--- @type CosmicUserConfig
local config = u.merge(default_config, user_config)
return config
