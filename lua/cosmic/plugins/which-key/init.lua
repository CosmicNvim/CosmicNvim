local user_config = require('cosmic.core.user')
return {
  { -- color scheme
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
    event = 'VeryLazy',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'which-key'),
  },
}
