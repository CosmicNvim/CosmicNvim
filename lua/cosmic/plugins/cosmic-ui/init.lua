local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  border_style = 'rounded',
}

return {
  'CosmicNvim/cosmic-ui',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('cosmic-ui').setup(u.merge(defaults, user_config.plugins.cosmic_ui or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'cosmic-ui'),
}
