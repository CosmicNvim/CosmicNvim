-- DEFAULT USER SETTINGS
local ok, user_config = pcall(require, 'cosmic.config.config')

if not ok then
  user_config = {}
end

local default_config = {
  border = 'rounded',
  disable_builtin_plugins = {},
  add_plugins = {},
  plugins = {
    lsp_lines = {
      -- additional flag only for CosmicNvim
      -- true - loads plugin and is enabled at start
      -- false - loads plugin but is not enabled at start
      -- you may use <leader>ld to toggle
      enable_on_start = false,
    },
  },
  lsp = {
    format_on_save = true, -- true/false or table of filetypes {'.ts', '.js',}
    format_timeout = 3000,
    rename_notification = true,
    -- table of callbacks pushed via plugins
    on_attach_mappings = {},
    -- lsp servers that should be installed
    ensure_installed = {
      'astro',
      --[[ 'actionlint', ]]
      --[[ 'eslint_d', ]]
      --[[ 'prettierd', ]]
      'bashls',
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

function config.lsp.can_client_format(client)
  -- formatting enabled by default if server=true
  if config.lsp.servers[client.name] == true then
    return true
  end

  -- check config server settings
  if config.lsp.servers[client.name] then
    -- default to true if no format flag on server settings is set
    if config.lsp.servers[client.name].format == nil then
      return true
    end

    -- check format flag on server settings
    return (config.lsp.servers[client.name].format == true)
  end

  return true
end

return config
