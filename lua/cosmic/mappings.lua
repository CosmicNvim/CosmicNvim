local g = vim.g
local map = require('cosmic.utils').map

g.mapleader = ' '

-- Quickfix
map('n', '<leader>ck', ':cexpr []<CR>', { noremap = true })
map('n', '<leader>cc', ':cclose <CR>', { noremap = true })
map('n', '<leader>co', ':copen <CR>', { noremap = true })
map('n', '<leader>cf', ':cfdo %s/', { noremap = true })

require('cosmic.core.file-navigation.mappings').init()
require('cosmic.core.file-explorer.mappings')
require('cosmic.core.terminal.mappings')
