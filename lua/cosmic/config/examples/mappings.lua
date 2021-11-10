-- Add additional keymaps or disable existing ones
-- To view maps set, use `:Telescope keymaps`
-- or `:map`, `:map <leader>`

local cmd = vim.cmd
local map = require('cosmic.utils').map

-- Example: Additional insert mapping:
map('i', 'jj', '<esc>', { noremap = true, silent = true })

-- Mapping options:
-- map('n', ...)
-- map('v', ...)
-- map('i', ...)
-- map('t', ...)

-- Example: Disable find files keymap
-- cmd('unmap <leader>f')
