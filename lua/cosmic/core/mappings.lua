local map = require('cosmic.utils').map

-- Quickfix mappings
map('n', '<leader>ck', ':cexpr []<cr>')
map('n', '<leader>cc', ':cclose <cr>')
map('n', '<leader>co', ':copen <cr>')
map('n', '<leader>cf', ':cfdo %s/')

require('cosmic.plugins.auto-session.mappings')
require('cosmic.plugins.telescope.mappings').init()
require('cosmic.plugins.nvim-tree.mappings')
require('cosmic.plugins.terminal.mappings')
require('cosmic.lsp.mappings')
