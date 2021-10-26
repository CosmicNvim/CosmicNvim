-- DO NOT TOUCH :)
local ok, user_config = pcall(require, 'cosmic.config.config')

if not ok then
  error(string.format('Error loading user config...\n\n%s', user_config))
  error('No user config, using default instead...')
end

if user_config == true then
  user_config = {}
end

-- these settings will be merged with any settings definined in config.lua
local default_config = {
  statusline = {
    main_icon = require('cosmic.core.theme.icons').ghost,
  },
  lsp = {
    format_on_save = true, -- true/false or table of filetypes {'.ts', '.js',}
    diagnostic = {
      signs = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'always',
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
        -- todo: icons for diagnostics?
        --[[ format = function(diagnostic)
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return string.format('E: %s', diagnostic.message)
        end
        return diagnostic.message
      end, ]]
      },
    },
    servers = {
      eslint = {
        format = false,
      }, -- enable/disable server + formatting
      -- rust_analyzer = true, -- enable non-default servers (todo: support for custom server configs)
      efm = {
        format = true, -- true or false
        disable_formatters = { 'eslint' }, -- e.g. 'eslint', 'prettier', 'stylua'
      },
      tsserver = {
        format = false, -- disable formatting all together
      },
    },
  },
}

local config = vim.tbl_deep_extend('force', default_config, user_config)
-- default servers that can be formatted
local user_servers = vim.tbl_keys(config.lsp.servers)
function config.lsp.can_client_format(client_name)
  if config.lsp.servers[client_name] == true then
    return true
  end

  if vim.tbl_contains(user_servers, client_name) and config.lsp.servers[client_name] then
    return (config.lsp.servers[client_name].format == true)
  end

  return false
end

return config
