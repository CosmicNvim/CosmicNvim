local map = require('cosmic.utils').map
local ok, user_plugins = pcall(require, 'cosmic.config.plugins')

-- Mappings for plugins that need to be lazy loaded
if ok then
  if not vim.tbl_contains(user_plugins.disable, 'nvim-tree') then
    require('cosmic.plugins.nvim-tree.mappings')
  end

  if not vim.tbl_contains(user_plugins.disable, 'auto-session') then
    require('cosmic.plugins.auto-session.mappings')
  end
end

-- Quickfix mappings
map('n', '<leader>ck', ':cexpr []<cr>')
map('n', '<leader>cc', ':cclose <cr>')
map('n', '<leader>co', ':copen <cr>')
map('n', '<leader>cf', ':cfdo %s/')
map('n', '<leader>cp', ':cprev<cr>zz')
map('n', '<leader>cn', ':cnext<cr>zz')

-- buffer navigation
map('n', '<leader>bp', ':bprev<cr>')
map('n', '<leader>bn', ':bnext<cr>')

-- tab navigation
map('n', '<leader>tp', ':tabprevious<cr>')
map('n', '<leader>tn', ':tabnext<cr>')

-- resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')
