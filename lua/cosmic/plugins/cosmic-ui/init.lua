local config = require('cosmic.config')
local icons = require('cosmic.theme.icons')

local defaults = {
  border = 'rounded',
  icons = icons,
}

require('cosmic-ui').setup(vim.tbl_deep_extend('force', defaults, config.cosmic_ui or {}))
