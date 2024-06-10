local user_config = require('cosmic.core.user')
local map = require('cosmic.utils').map
local create_buf_map = require('cosmic.utils').create_buf_map
return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup({
      direction = 'float',
      float_opts = {
        border = user_config.border,
      },
    })

    local Terminal = require('toggleterm.terminal').Terminal

    function new_terminal()
      local terminal = Terminal:new({
        on_open = function(term)
          local buf_map = create_buf_map(term.bufnr, {
            noremap = false,
          })
          vim.cmd('startinsert!')
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd('startinsert!')
        end,
      })
      terminal:toggle()
    end

    map('n', '<C-l>', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
    map('t', '<esc>', [[<C-\><C-n>]], { desc = 'Close Floaterm' })
    map('t', '<C-w>n', new_terminal, { desc = 'New terminal' })
  end,
  lazy = false,
}
