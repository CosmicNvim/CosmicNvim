local map = require('cosmic.utils').map

-- Quickfix mappings
map('n', '<leader>ck', ':cexpr []<cr>')
map('n', '<leader>cc', ':cclose <cr>')
map('n', '<leader>co', ':copen <cr>')
map('n', '<leader>cf', ':cfdo %s/')

require('cosmic.modules.session.mappings')
require('cosmic.modules.telescope.mappings').init()
require('cosmic.modules.nvim-tree.mappings')
require('cosmic.modules.terminal.mappings')
require('cosmic.lsp.mappings')
