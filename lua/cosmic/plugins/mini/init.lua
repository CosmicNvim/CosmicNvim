local user_config = require('cosmic.core.user')
return {
  'nvim-mini/mini.nvim',
  version = false,
  init = function()
    require('mini.ai').setup()
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'mini'),
}
