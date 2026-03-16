local diagnostics_defaults = require('cosmic.lsp.diagnostics.defaults')
local u = require('cosmic.utils')
local modules = require('cosmic.utils.modules')

---@diagnostic disable: missing-fields
---@class CosmicUserConfigLspServer : vim.lsp.ClientConfig
---@field format_on_save? boolean

---@alias CosmicUserConfigLspServerSetting CosmicUserConfigLspServer|boolean

---@class CosmicRawUserConfigLsp
---@field format_timeout? number
---@field inlay_hint? boolean
---@field servers? table<string, CosmicUserConfigLspServerSetting>

---@class CosmicRawUserConfig
---@field diagnostics? vim.diagnostic.Opts
---@field lsp? CosmicRawUserConfigLsp
---@field plugins? LazySpec[]|table

---@class CosmicUserConfigLsp
---@field format_timeout number
---@field format_on_save_disabled table<string, boolean>
---@field inlay_hint boolean
---@field resolved_servers table<string, vim.lsp.ClientConfig>
---@field servers table<string, CosmicUserConfigLspServerSetting>

---@class CosmicUserConfig
---@field diagnostics vim.diagnostic.Opts
---@field lsp CosmicUserConfigLsp
---@field plugins LazySpec[]

---@type table<string, CosmicUserConfigLspServerSetting>
local default_lsp_servers = {
  astro = true,
  cssls = true,
  eslint = true,
  gopls = true,
  html = true,
  jsonls = true,
  lua_ls = true,
  -- Disable in favor of conform ruff
  basedpyright = {
    format_on_save = false,
  },
  -- Disable in favor of conform ruff
  ruff = {
    format_on_save = false,
  },
  tailwindcss = true,
  vtsls = {
    format_on_save = false,
  },
}

---@type CosmicUserConfig
local default_config = {
  diagnostics = vim.deepcopy(diagnostics_defaults),
  lsp = {
    format_timeout = 500,
    format_on_save_disabled = {},
    inlay_hint = false,
    resolved_servers = {},
    servers = vim.deepcopy(default_lsp_servers),
  },
  plugins = {},
}

local function config_error(message)
  error('[CosmicNvim] ' .. message, 0)
end

---@return CosmicRawUserConfig
local function load_user_config()
  local config = modules.optional_require('cosmic.config.config')
  if config == nil then
    return {}
  end

  if type(config) ~= 'table' then
    config_error('`lua/cosmic/config/config.lua` must return a table.')
  end

  return config
end

---@param plugins LazySpec[]|table|nil
---@return LazySpec[]
local function normalize_plugins(plugins)
  if plugins == nil then
    return {}
  end

  if type(plugins) ~= 'table' or not vim.tbl_islist(plugins) then
    config_error('`plugins` must be a list of lazy.nvim specs.')
  end

  return vim.deepcopy(plugins)
end

---@param diagnostics vim.diagnostic.Opts|table|nil
---@return vim.diagnostic.Opts
local function normalize_diagnostics(diagnostics)
  if diagnostics == nil then
    return vim.deepcopy(default_config.diagnostics)
  end

  if type(diagnostics) ~= 'table' then
    config_error('`diagnostics` must be a table.')
  end

  return u.merge(vim.deepcopy(diagnostics_defaults), diagnostics)
end

---@param server_name string
---@param server_config CosmicUserConfigLspServerSetting
local function validate_server_config(server_name, server_config)
  if type(server_config) ~= 'boolean' and type(server_config) ~= 'table' then
    config_error(('`lsp.servers.%s` must be `true`, `false`, or a table of LSP config fields.'):format(server_name))
  end

  if type(server_config) == 'table' and server_config.opts ~= nil then
    config_error(
      ('`lsp.servers.%s.opts` is not supported. Put LSP config fields directly under `lsp.servers.%s`.'):format(
        server_name,
        server_name
      )
    )
  end
end

---@param servers table<string, CosmicUserConfigLspServerSetting>
---@return table<string, vim.lsp.ClientConfig>, table<string, boolean>
local function resolve_lsp_servers(servers)
  local resolved_servers = {}
  local format_on_save_disabled = {}
  local base_server_config = require('cosmic.lsp.servers.defaults')

  for server_name, server_config in pairs(servers) do
    if server_config ~= false then
      local resolved_config = vim.deepcopy(base_server_config)
      local cosmic_server_config = modules.optional_require('cosmic.lsp.servers.' .. server_name)

      if type(cosmic_server_config) == 'table' then
        resolved_config = u.merge(resolved_config, cosmic_server_config)
      end

      if type(server_config) == 'table' then
        local user_server_config = vim.deepcopy(server_config)
        if user_server_config.format_on_save == false then
          format_on_save_disabled[server_name] = true
        end
        user_server_config.format_on_save = nil
        resolved_config = u.merge(resolved_config, user_server_config)
      end

      resolved_servers[server_name] = resolved_config
    end
  end

  return resolved_servers, format_on_save_disabled
end

---@param lsp CosmicRawUserConfigLsp|nil
---@return CosmicUserConfigLsp
local function normalize_lsp(lsp)
  if lsp == nil then
    lsp = {}
  end

  if type(lsp) ~= 'table' then
    config_error('`lsp` must be a table.')
  end

  if lsp.servers ~= nil and type(lsp.servers) ~= 'table' then
    config_error('`lsp.servers` must be a table.')
  end

  local servers = u.merge(vim.deepcopy(default_lsp_servers), vim.deepcopy(lsp.servers or {}))
  for server_name, server_config in pairs(servers) do
    validate_server_config(server_name, server_config)
  end

  local resolved_servers, format_on_save_disabled = resolve_lsp_servers(servers)

  return {
    format_timeout = lsp.format_timeout == nil and default_config.lsp.format_timeout or lsp.format_timeout,
    format_on_save_disabled = format_on_save_disabled,
    inlay_hint = lsp.inlay_hint == nil and default_config.lsp.inlay_hint or lsp.inlay_hint,
    resolved_servers = resolved_servers,
    servers = servers,
  }
end

local raw_user_config = load_user_config()

---@type CosmicUserConfig
local config = {
  diagnostics = normalize_diagnostics(raw_user_config.diagnostics),
  lsp = normalize_lsp(raw_user_config.lsp),
  plugins = normalize_plugins(raw_user_config.plugins),
}

return config
