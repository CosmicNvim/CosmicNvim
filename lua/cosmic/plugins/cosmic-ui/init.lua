local config = require('cosmic.config')

local defaults = {
  border = 'rounded',
}

require('cosmic-ui').setup(vim.tbl_deep_extend('force', defaults, config.cosmic_ui or {}))
