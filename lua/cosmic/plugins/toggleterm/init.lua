local user_config = require('cosmic.core.user')
local map = require('cosmic.utils').set_keymap
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
    local terminal_utils = require('cosmic.plugins.toggleterm.utils')

    map('t', '<leader>k', [[<C-\><C-n>]], { desc = 'Visual mode' })

    -- toggle terminals
    map('n', '<leader>kk', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
    map('t', '<leader>kk', [[<C-\><C-n>]] .. ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })

    -- new terminal
    map('n', '<leader>kn', terminal_utils.new_terminal, { desc = 'New terminal' })
    map('t', '<leader>kn', terminal_utils.new_terminal, { desc = 'New terminal' })

    -- select terminal to open
    map('n', '<leader>kf', ':TermSelect<CR>', { desc = 'Choose open terminal' })
    map('t', '<leader>kf', [[<C-\><C-n>]] .. ':TermSelect<CR>', { desc = 'Choose open terminal' })

    -- rename terminal
    map('n', '<leader>kr', ':ToggleTermSetName<CR>', { desc = 'Rename terminal', buffer = 0 })
    map('t', '<leader>kr', [[<C-\><C-n>]] .. ':ToggleTermSetName<CR>', { desc = 'Rename terminal', buffer = 0 })

    -- terminal only mappings
    vim.cmd("autocmd! TermOpen term://* lua require('cosmic.plugins.toggleterm.utils').set_terminal_keymaps()")
  end,
  lazy = false,
}
