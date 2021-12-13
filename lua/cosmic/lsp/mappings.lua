local map = require('cosmic.utils').map

-- Mappings.

-- See `:help vim.lsp.*` for documentation on any of the below functions
map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
map('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
map('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')

-- diagnostics
map('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
map('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
map('n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

-- hover
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

-- code actions
map('n', '<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
map('v', '<leader>ga', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

-- formatting
map('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
map('v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

-- signature help
map('n', '<C-K>', '<cmd>lua require("lsp_signature").signature()<cr>')

-- lsp workspace
map('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
map(
  'n',
  '<leader>wl',
  '<cmd>lua require("cosmic.utils.logger"):log(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
)

-- typescript helpers
map('n', '<leader>gr', ':TSLspRenameFile<CR>')
map('n', '<leader>go', ':TSLspOrganize<CR>')
map('n', '<leader>gi', ':TSLspImportAll<CR>')
