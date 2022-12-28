local user_config = require('cosmic.core.user')

return {
  'hrsh7th/nvim-cmp',
  config = function()
    require('cosmic.plugins.nvim-cmp.config')
  end,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    -- has configs
    'L3MON4D3/LuaSnip',
  },
  event = 'InsertEnter',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-cmp'),
}
