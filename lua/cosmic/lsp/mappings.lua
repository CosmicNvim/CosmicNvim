local map = require('cosmic.utils').map
local M = {}

-- Mappings.
function M.init(client, bufnr)
  local function buf_map(mode, lhs, rhs)
    map(mode, lhs, rhs, {
      buffer = bufnr,
    })
  end

  buf_map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  buf_map('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
  buf_map('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
  buf_map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
  buf_map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')

  -- diagnostics
  buf_map('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  buf_map('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  buf_map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
  buf_map('n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

  -- hover
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

  -- code actions
  buf_map('n', '<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
  buf_map('v', '<leader>ga', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

  -- formatting
  buf_map('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
  buf_map('v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

  -- lsp workspace
  buf_map('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
  buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  buf_map(
    'n',
    '<leader>wl',
    '<cmd>lua require("cosmic.utils.logger"):log(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
  )

  if client.name == 'tsserver' then
    -- typescript helpers
    buf_map('n', '<leader>gr', ':TSLspRenameFile<CR>')
    buf_map('n', '<leader>go', ':TSLspOrganize<CR>')
    buf_map('n', '<leader>gi', ':TSLspImportAll<CR>')
  end
end

return M
