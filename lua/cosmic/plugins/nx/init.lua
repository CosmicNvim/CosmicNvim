local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'Equilibris/nx.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  opts = u.merge({
    -- See below for config options
    nx_cmd_root = 'yarn nx',
  }, user_config.plugins.nx or {}),
  -- Plugin will load when you use these keys
  keys = {
    { '<leader>nx', '<cmd>Telescope nx actions<CR>', desc = 'nx actions' },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nx'),
}
