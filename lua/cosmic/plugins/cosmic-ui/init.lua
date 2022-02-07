local config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  border_style = 'rounded',
}

require('cosmic-ui').setup(u.merge(defaults, config.cosmic_ui or {}))
