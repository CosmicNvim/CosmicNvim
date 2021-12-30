local config = require('cosmic.config')
local utils = require('cosmic.utils')

local defaults = {
  border = 'rounded',
}

require('cosmic-ui').setup(utils.merge(defaults, config.cosmic_ui or {}))
