local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local config = u.merge({

  -- use the night style
  style = 'night',
  light_style = 'moon',
  sidebars = { 'qf', 'packer', 'help' },
}, user_config.plugins.tokyonight or {})

return config
