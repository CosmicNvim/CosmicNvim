local map = require('cosmic.utils').map

map('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle Tree' })
map('n', '<leader>r', ':NvimTreeRefresh<CR>', { desc = 'Refresh Tree' })
