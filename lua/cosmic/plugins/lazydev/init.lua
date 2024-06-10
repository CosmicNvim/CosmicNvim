local user_config = require('cosmic.core.user')
return {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      'lazy.nvim',
      'toggleterm.nvim',
      --[[ { path = 'plenary.nvim/lua/plenary', words = { 'plenary' } }, ]]
    },
  },
  dependencies = { { 'Bilal2453/luvit-meta', lazy = true } },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lazydev'),
  event = 'VeryLazy',
}
