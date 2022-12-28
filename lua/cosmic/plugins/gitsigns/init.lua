local user_config = require('cosmic.core.user')

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opt = true,
  event = 'BufWinEnter',
  config = function()
    require('cosmic.plugins.gitsigns.config')
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
}
