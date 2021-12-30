local M = {}

-- Mappings.
function M.init(client, bufnr)
  local buf_map = require('cosmic.utils').buf_map

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_map(bufnr, 'n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
  buf_map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  buf_map(bufnr, 'n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
  buf_map(bufnr, 'n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
  buf_map(bufnr, 'n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
  buf_map(bufnr, 'n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')

  -- diagnostics
  buf_map(bufnr, 'n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  buf_map(bufnr, 'n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  buf_map(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
  buf_map(bufnr, 'n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

  -- hover
  buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

  -- code actions
  buf_map(bufnr, 'n', '<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
  buf_map(bufnr, 'v', '<leader>ga', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

  -- formatting
  buf_map(bufnr, 'n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
  buf_map(bufnr, 'v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

  -- signature help
  buf_map(bufnr, 'n', '<C-K>', '<cmd>lua require("lsp_signature").signature()<cr>')

  -- lsp workspace
  buf_map(bufnr, 'n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
  buf_map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  buf_map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  buf_map(
    bufnr,
    'n',
    '<leader>wl',
    '<cmd>lua require("cosmic.utils.logger"):log(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
  )

  if client.name == 'tsserver' then
    -- typescript helpers
    buf_map(bufnr, 'n', '<leader>gr', ':TSLspRenameFile<CR>')
    buf_map(bufnr, 'n', '<leader>go', ':TSLspOrganize<CR>')
    buf_map(bufnr, 'n', '<leader>gi', ':TSLspImportAll<CR>')
  end
end

return M
