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
    require('cosmic.plugins.telescope.config')
  end,
  init = function()
    require('cosmic.plugins.telescope.mappings').init()
  end,
  cmd = { 'Telescope' },
  keys = {
    {
      '<leader>ff',
      '<cmd>lua require("cosmic.plugins.telescope.mappings").project_files()<cr>',
      desc = 'Project find files',
    },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'telescope'),
}
