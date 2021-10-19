local map = require('cosmic.utils').map

map('n', '<C-l>', ':FloatermToggle<CR>', { noremap = true })
map('t', '<C-l>', [[<C-\><C-n>]], { noremap = true })
map('t', '<C-w>l', [[<C-\><C-n>:FloatermNext<CR>]], { noremap = true })
map('t', '<C-w>h', [[<C-\><C-n>:FloatermPrev<CR>]], { noremap = true })
map('t', '<C-w>n', [[<C-\><C-n>:FloatermNew<CR>]], { noremap = true })
map('t', '<C-w>c', [[<C-\><C-n>:FloatermKill<CR>]], { noremap = true })
