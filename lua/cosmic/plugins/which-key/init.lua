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
        window = {
          border = user_config.border, -- none, single, double, shadow
          position = 'bottom', -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 3, 2, 3, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 20,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 8, -- spacing between columns
          align = 'center', -- align columns left, center or right
        },
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
            d = {
              name = '+diagnostics',
            },
            t = {
              name = '+toggle',
            },
            w = {
              name = '+workspace',
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
