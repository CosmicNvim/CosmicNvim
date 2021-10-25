local config = require('cosmic.config.config')

local default_config = {
  lsp = {
    format_on_save = false,
    servers = {
      eslint = true,
      efm = {
        disable_formatters = { 'eslint', },
      },
    },
  },
}

return vim.tbl_deep_extend('force', default_config, config)
