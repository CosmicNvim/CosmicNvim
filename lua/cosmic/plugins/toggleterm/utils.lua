local M = {}
local map = require('cosmic.utils').set_keymap
local Terminal = require('toggleterm.terminal').Terminal

function M.new_terminal()
  local terminal = Terminal:new()
  terminal:toggle()
end

function M.set_terminal_keymaps()
   map('t', '<C-n>', [[<C-\><C-n>]], { desc = 'Visual mode' })
  -- map('t', '<leader>xx', [[<C-\><C-n>]] .. ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
  -- map('t', '<leader>xn', M.new_terminal, { desc = 'New terminal' })
  -- map('t', '<leader>fx', [[<C-\><C-n>]] .. ':TermSelect<CR>', { desc = 'Find open terminal' })
  -- map('t', '<leader>xr', [[<C-\><C-n>]] .. ':ToggleTermSetName<CR>', { desc = 'Rename terminal', buffer = 0 })
end

return M
