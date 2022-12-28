local user_config = require('cosmic.core.user')
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  config = function()
    require('cosmic.plugins.telescope.mappings').init()
    require('cosmic.plugins.telescope.config')
  end,
  event = 'BufWinEnter',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'telescope'),
}
