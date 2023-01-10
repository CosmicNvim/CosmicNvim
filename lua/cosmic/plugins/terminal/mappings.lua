local map = require('cosmic.utils').map

map('n', '<C-l>', ':FloatermToggle<CR>', { desc = 'Toggle Floaterm' })
map('t', '<C-l>', [[<C-\><C-n>]], { desc = 'Close Floaterm' })
map('t', '<C-w>l', [[<C-\><C-n>:FloatermNext<CR>]], { desc = 'Next terminal' })
map('t', '<C-w>h', [[<C-\><C-n>:FloatermPrev<CR>]], { desc = 'Prev terminal' })
map('t', '<C-w>n', [[<C-\><C-n>:FloatermNew<CR>]], { desc = 'New terminal' })
map('t', '<C-w>c', [[<C-\><C-n>:FloatermKill<CR>]], { desc = 'Kill current terminal' })
