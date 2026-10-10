local diagnostics_defaults = require('cosmic.lsp.diagnostics.defaults')
local u = require('cosmic.utils')
local modules = require('cosmic.utils.modules')

---@diagnostic disable: missing-fields
---@class CosmicUserConfigLspServer : vim.lsp.ClientConfig
---@field format_on_save? boolean
---@field formatting? boolean
---@field mason? boolean

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
---@field formatting_disabled table<string, boolean>
---@field inlay_hint boolean
---@field mason_servers table<string, boolean>
---@field resolved_servers table<string, vim.lsp.ClientConfig>

---@class CosmicUserConfig
---@field diagnostics vim.diagnostic.Opts
---@field load_error? string Why config.lua was replaced with defaults, for :checkhealth
---@field lsp CosmicUserConfigLsp
---@field plugins LazySpec[]

---@type table<string, CosmicUserConfigLspServerSetting>
local default_lsp_servers = {
  astro = true,
  basedpyright = {
    format_on_save = false,
  },
  cssls = true,
  eslint = true,
  gopls = true,
  html = true,
  jsonls = true,
  lua_ls = true,
  -- Disable in favor of conform ruff
  ruff = {
    format_on_save = false,
  },
  tailwindcss = true,
  tsc = {
    format_on_save = false,
  },
}

-- Daemons like eslint_d and prettierd need time to start on the first save in a project.
local default_lsp_format_timeout = 3000
local default_lsp_inlay_hint = false

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

  if type(plugins) ~= 'table' or not vim.islist(plugins) then
    config_error('`plugins` must be a list of lazy.nvim specs.')
  end

  return vim.deepcopy(plugins)
end

---@param diagnostics vim.diagnostic.Opts|table|nil
---@return vim.diagnostic.Opts
local function normalize_diagnostics(diagnostics)
  if diagnostics == nil then
    return vim.deepcopy(diagnostics_defaults)
  end

  if type(diagnostics) ~= 'table' then
    config_error('`diagnostics` must be a table.')
  end

  return u.merge(vim.deepcopy(diagnostics_defaults), diagnostics)
end

---@param server_name string
---@param server_config CosmicUserConfigLspServerSetting
local function validate_server_config(server_name, server_config)
  if type(server_name) ~= 'string' then
    config_error('`lsp.servers` must map server names to settings, for example `rust_analyzer = true`.')
  end

  if type(server_config) ~= 'boolean' and type(server_config) ~= 'table' then
    config_error(('`lsp.servers.%s` must be `true`, `false`, or a table of LSP config fields.'):format(server_name))
  end

  if type(server_config) ~= 'table' then
    return
  end

  if server_config.opts ~= nil then
    config_error(
      ('`lsp.servers.%s.opts` is not supported. Put LSP config fields directly under `lsp.servers.%s`.'):format(
        server_name,
        server_name
      )
    )
  end

  for _, flag in ipairs({ 'format_on_save', 'formatting', 'mason' }) do
    if server_config[flag] ~= nil and type(server_config[flag]) ~= 'boolean' then
      config_error(('`lsp.servers.%s.%s` must be `true` or `false`.'):format(server_name, flag))
    end
  end
end

---@param user_servers table<string, CosmicUserConfigLspServerSetting>|nil
---@return table<string, CosmicUserConfigLspServerSetting>
local function merge_servers(user_servers)
  local servers = vim.deepcopy(default_lsp_servers)
  for server_name, server_config in pairs(vim.deepcopy(user_servers or {})) do
    local default = servers[server_name]
    if type(default) == 'table' and type(server_config) == 'table' then
      servers[server_name] = u.merge(default, server_config)
    elseif not (server_config == true and type(default) == 'table') then
      -- `true` enables a server with Cosmic's defaults for it, so only other values replace them
      servers[server_name] = server_config
    end
  end
  return servers
end

---@param user_servers table<string, CosmicUserConfigLspServerSetting>|nil
---@return table<string, vim.lsp.ClientConfig>, table<string, boolean>, table<string, boolean>, table<string, boolean>
local function normalize_servers(user_servers)
  local servers = merge_servers(user_servers)
  local resolved_servers = {}
  local format_on_save_disabled = {}
  local formatting_disabled = {}
  local mason_servers = {}

  for server_name, server_config in pairs(servers) do
    validate_server_config(server_name, server_config)

    if server_config ~= false then
      if type(server_config) == 'table' then
        local user_server_config = vim.deepcopy(server_config)
        if user_server_config.format_on_save == false then
          format_on_save_disabled[server_name] = true
        end
        if user_server_config.formatting == false then
          formatting_disabled[server_name] = true
        end
        if user_server_config.mason ~= false then
          mason_servers[server_name] = true
        end
        user_server_config.format_on_save = nil
        user_server_config.formatting = nil
        user_server_config.mason = nil
        resolved_servers[server_name] = user_server_config
      else
        mason_servers[server_name] = true
        resolved_servers[server_name] = {}
      end
    end
  end

  return resolved_servers, format_on_save_disabled, formatting_disabled, mason_servers
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

  if lsp.format_timeout ~= nil and (type(lsp.format_timeout) ~= 'number' or lsp.format_timeout <= 0) then
    config_error('`lsp.format_timeout` must be a positive number of milliseconds.')
  end

  if lsp.inlay_hint ~= nil and type(lsp.inlay_hint) ~= 'boolean' then
    config_error('`lsp.inlay_hint` must be `true` or `false`.')
  end

  local resolved_servers, format_on_save_disabled, formatting_disabled, mason_servers = normalize_servers(lsp.servers)

  return {
    format_timeout = lsp.format_timeout == nil and default_lsp_format_timeout or lsp.format_timeout,
    format_on_save_disabled = format_on_save_disabled,
    formatting_disabled = formatting_disabled,
    inlay_hint = lsp.inlay_hint == nil and default_lsp_inlay_hint or lsp.inlay_hint,
    mason_servers = mason_servers,
    resolved_servers = resolved_servers,
  }
end

---@param raw_user_config CosmicRawUserConfig
---@return CosmicUserConfig
local function normalize(raw_user_config)
  return {
    diagnostics = normalize_diagnostics(raw_user_config.diagnostics),
    lsp = normalize_lsp(raw_user_config.lsp),
    plugins = normalize_plugins(raw_user_config.plugins),
  }
end

-- A broken user config should not disable formatting, LSP and mappings: report it and use the defaults.
local ok, config = pcall(function()
  return normalize(load_user_config())
end)
if not ok then
  local err = tostring(config):gsub('^%[CosmicNvim%] ', '')
  vim.schedule(function()
    vim.notify(
      ('[CosmicNvim] Error in lua/cosmic/config/config.lua: %s\nUsing default settings until it is fixed.'):format(err),
      vim.log.levels.ERROR
    )
  end)
  config = normalize({})
  config.load_error = err
end

return config
