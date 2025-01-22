local user_config = require('cosmic.core.user')
return {
  { -- color scheme
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {
      -- use the night style
      style = 'night',
      light_style = 'moon',
      sidebars = { 'qf', 'packer', 'help' },
    },
    init = function()
      vim.cmd('color tokyonight')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'tokyonight'),
  },
}
