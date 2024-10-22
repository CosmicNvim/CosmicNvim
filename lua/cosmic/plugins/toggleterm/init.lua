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

    -- toggle terminals
    map('n', '<leader>xx', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })

    -- new terminal
    map('n', '<leader>xn', terminal_utils.new_terminal, { desc = 'New terminal' })

    -- select terminal to open
    map('n', '<leader>fx', ':TermSelect<CR>', { desc = 'Find open terminal' })

    -- rename terminal
    map('n', '<leader>xr', ':ToggleTermSetName<CR>', { desc = 'Rename terminal', buffer = 0 })

    -- terminal only mappings
    vim.cmd("autocmd! TermOpen term://* lua require('cosmic.plugins.toggleterm.utils').set_terminal_keymaps()")
  end,
  lazy = false,
}
