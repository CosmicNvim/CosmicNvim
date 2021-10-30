local map = require('cosmic.utils').map

-- Quickfix
map('n', '<leader>ck', ':cexpr []<cr>')
map('n', '<leader>cc', ':cclose <cr>')
map('n', '<leader>co', ':copen <cr>')
map('n', '<leader>cf', ':cfdo %s/')

map('n', '<leader>cp', ':cprev <cr>')
map('n', '<leader>cn', ':cnext <cr>')

map('n', '<leader>bp', ':bprev <cr>')
map('n', '<leader>bn', ':bnext <cr>')

require('cosmic.core.navigation.mappings')
require('cosmic.core.file-explorer.mappings')
require('cosmic.core.terminal.mappings')
require('cosmic.lsp.mappings')
