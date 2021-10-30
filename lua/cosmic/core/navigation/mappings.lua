local map = require('cosmic.utils').map

map('n', '<leader>p', ':Telescope find_files<CR>')
map('n', '<leader>f', ':Telescope git_files<CR>')
map('n', '<leader>k', ':Telescope buffers<CR>')
map('n', '<leader>s', ':Telescope live_grep<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>gs', ':Telescope git_status<CR>')
