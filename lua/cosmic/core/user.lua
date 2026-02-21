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

--- @class CosmicUserPluginConfig
--- @field add? LazySpec[]
--- @field disable? string[]
--- @field opts? table<string, any>
--- @field override? table<string, LazySpec>

--- @class CosmicUserConfig
--- @field add_plugins LazySpec[]
--- @field diagnostics? vim.diagnostic.Opts
--- @field lsp CosmicUserConfigLsp
--- @field plugins CosmicUserPluginConfig

--- @type CosmicUserConfig
local default_config = {
  add_plugins = {},
  plugins = {
    add = {},
    disable = {},
    opts = {},
    override = {},
  },
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

if user_config.disable_builtin_plugins ~= nil then
  vim.notify_once(
    '[CosmicNvim] `disable_builtin_plugins` has been removed. Use `plugins.disable` with plugin repository IDs.',
    vim.log.levels.WARN
  )
end

---@param config CosmicUserConfig
---@return CosmicUserConfig
local function normalize_plugin_config(config)
  local plugin_config = type(config.plugins) == 'table' and config.plugins or {}
  local add_plugins = vim.deepcopy(config.add_plugins or {})

  u.merge_list(add_plugins, vim.deepcopy(plugin_config.add or {}))

  if type(plugin_config.opts) == 'table' then
    for plugin_name, plugin_opts in pairs(plugin_config.opts) do
      table.insert(add_plugins, {
        plugin_name,
        opts = plugin_opts,
      })
    end
  end

  if type(plugin_config.override) == 'table' then
    for plugin_name, override_spec in pairs(plugin_config.override) do
      if type(override_spec) == 'table' then
        local user_spec = vim.deepcopy(override_spec)
        user_spec[1] = plugin_name
        table.insert(add_plugins, user_spec)
      end
    end
  end

  if type(plugin_config.disable) == 'table' then
    for _, plugin_name in ipairs(plugin_config.disable) do
      table.insert(add_plugins, {
        plugin_name,
        enabled = false,
      })
    end
  end

  config.add_plugins = add_plugins
  return config
end

--- @type CosmicUserConfig
local config = u.merge(default_config, user_config)
config = normalize_plugin_config(config)
return config
