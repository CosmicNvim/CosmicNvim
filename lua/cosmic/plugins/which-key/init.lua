local user_config = require('cosmic.core.user')
return {
  { -- color scheme
    'folke/which-key.nvim',
    config = function()
      local wk = require('which-key')
      wk.setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })

      wk.register({
        ['<leader>'] = {
          b = {
            name = '+buffer',
          },
          c = {
            name = '+quickfix',
          },
          f = {
            name = '+find',
          },
          h = {
            name = '+gitsigns',
            t = {
              name = '+toggle',
            },
          },
          l = {
            name = '+lsp',
            t = {
              name = '+toggle',
            },
          },
          g = {
            name = '+goto (lsp)',
          },
          n = {
            name = '+tree',
          },
          s = {
            name = '+session',
          },
          t = {
            name = '+tab',
          },
          v = {
            name = '+vcs (git)',
            t = {
              name = '+toggle',
            },
          },
        },
      })
    end,
    event = 'VeryLazy',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'which-key'),
  },
}
