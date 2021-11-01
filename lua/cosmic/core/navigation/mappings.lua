local map = require('cosmic.utils').map

-- navigation
map('n', '<leader>sf', ':Telescope find_files<cr>')
map('n', '<leader>sg', ':Telescope git_files<cr>')
map('n', '<leader>sk', ':Telescope buffers<cr>')
map('n', '<leader>ss', ':Telescope live_grep<cr>')

-- git navigation
map('n', '<leader>ggc', ':Telescope git_commits<cr>')
map('n', '<leader>ggs', ':Telescope git_status<cr>')

-- quickfix navigation
map('n', '<leader>cp', ':cprev<cr>')
map('n', '<leader>cn', ':cnext<cr>')

-- buffer navigation
map('n', '<leader>bp', ':bprev<cr>')
map('n', '<leader>bn', ':bnext<cr>')

-- tab navigation
map('n', '<leader>tp', ':tprev<cr>')
map('n', '<leader>tn', ':tnext<cr>')
