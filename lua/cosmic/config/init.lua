local user_config = require('cosmic.config.config')

-- these settings will be merged with any settings definined in config.lua
local default_config = {
  lsp = {
    format_on_save = false,
    servers = {
      eslint = false,
      efm = {
        format = true,
        disable_formatters = {}, -- e.g. 'eslint', 'prettier', 'stylua'
      },
      tsserver = {
        format = false,
      }
    },
  },
}

local config =  vim.tbl_deep_extend('force', default_config, user_config)

-- default servers that can be formatted
local formatting_servers = { 'efm', 'eslint', 'tsserver', 'sumneko_lua', 'rust_analyzer', 'gopls', 'pyright' }
function default_config.lsp.can_client_format(client_name)
  return (config.lsp.servers[client_name] and config.lsp.servers[client_name].format and vim.tbl_contains(formatting_servers, client_name))
end

return config
