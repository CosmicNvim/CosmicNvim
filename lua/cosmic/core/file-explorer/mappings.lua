local map = require('cosmic.utils').map

map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
map('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true })
