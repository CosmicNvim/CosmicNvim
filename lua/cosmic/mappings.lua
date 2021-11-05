local map = require('cosmic.utils').map

-- Quickfix mappings
map('n', '<leader>ck', ':cexpr []<cr>')
map('n', '<leader>cc', ':cclose <cr>')
map('n', '<leader>co', ':copen <cr>')
map('n', '<leader>cf', ':cfdo %s/')

-- make Y behave like others
map('n', 'Y', 'y$')

require('cosmic.core.session.mappings')
require('cosmic.core.navigation.mappings').init()
require('cosmic.core.file-explorer.mappings')
require('cosmic.core.terminal.mappings')
require('cosmic.lsp.mappings')
