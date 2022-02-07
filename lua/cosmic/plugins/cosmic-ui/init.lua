local config = require('cosmic.core.user')
local utils = require('cosmic.utils')

local defaults = {
  border_style = 'rounded',
}

require('cosmic-ui').setup(utils.merge(defaults, config.cosmic_ui or {}))
