local map = require('cosmic.utils').map

map('n', '<C-l>', ':FloatermToggle<CR>')
map('t', '<C-l>', [[<C-\><C-n>]])
map('t', '<C-w>l', [[<C-\><C-n>:FloatermNext<CR>]])
map('t', '<C-w>h', [[<C-\><C-n>:FloatermPrev<CR>]])
map('t', '<C-w>n', [[<C-\><C-n>:FloatermNew<CR>]])
map('t', '<C-w>c', [[<C-\><C-n>:FloatermKill<CR>]])
