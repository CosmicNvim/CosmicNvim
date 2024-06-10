local user_config = require('cosmic.core.user')
local map = require('cosmic.utils').set_keymap
local create_buf_map = require('cosmic.utils').create_buf_map
return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup({
      direction = 'float',
      float_opts = {
        border = user_config.border,
      },
      highlights = {
        FloatBorder = {
          link = 'FloatBorder',
        },
      },
    })

    local Terminal = require('toggleterm.terminal').Terminal

    local function new_terminal()
      local terminal = Terminal:new()
      terminal:toggle()
    end

    map('n', '<leader>kn', new_terminal, { desc = 'New terminal' })

    map('n', '<leader>k', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
    map('t', '<leader>k', [[<C-\><C-n>]] .. ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
    map('n', '<leader>kk', ':TermSelect<CR>', { desc = 'Choose open terminal' })
    map('t', '<leader>kk', [[<C-\><C-n>]] .. ':TermSelect<CR>', { desc = 'Choose open terminal' })

    map('t', '<esc>', [[<C-\><C-n>]], { desc = 'Visual mode' })
    map('t', '<leader>kn', new_terminal, { desc = 'New terminal' })
    map('n', '<leader>kr', ':ToggleTermSetName<CR>', { desc = 'Rename terminal' })

    -- @TODO: close all
  end,
  lazy = false,
}
