local u = require('cosmic.utils')
local M = {}

-- Mappings.
function M.init(client, bufnr)
  local buf_map = u.create_buf_map({
    buffer = bufnr,
    noremap = false,
  })

  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  buf_map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

  -- diagnostics
  buf_map('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  buf_map('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  buf_map('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
  buf_map('n', '<leader>ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "buffer", })<cr>')

  -- hover
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

  -- code actions
  buf_map('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<cr>')
  buf_map('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_actions()<cr>')
  buf_map('v', '<leader>ga', '<cmd>lua vim.lsp.buf.range_code_actions()<cr>')

  -- formatting
  buf_map('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
  buf_map('v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

  -- lsp workspace
  buf_map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  buf_map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  buf_map(
    'n',
    '<leader>wl',
    '<cmd>lua require("cosmic.utils.logger"):log(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
  )
end

return M
