local map = require('cosmic.utils').map

-- Mappings.
local opts = { noremap = true, silent = true }
local popup_opts = '{ border = "single", focusable = false, }'
local win_opts = '{ popup_opts = ' .. popup_opts .. '}'

-- See `:help vim.lsp.*` for documentation on any of the below functions
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
map('n', 'gn', '<cmd>lua require("cosmic.core.theme.ui").rename()<CR>', opts)
map('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev(' .. win_opts .. ')<CR>', opts)
map('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next(' .. win_opts .. ')<CR>', opts)
map('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics(' .. popup_opts .. ')<CR>', opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<space>ga', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
map('v', '<space>ga', '<cmd>lua require("telescope.builtin").lsp_range_code_actions()<CR>', opts)
map('n', '<space>gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
map('n', '<C-k>', '<cmd>lua require("lsp_signature").signature()<CR>', opts)

map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

-- no default maps, so you may want to define some here
map('n', '<space>gr', ':TSLspRenameFile<CR>', opts)
map('n', '<space>go', ':TSLspOrganize<CR>', opts)
map('n', '<space>gi', ':TSLspImportAll<CR>', opts)
