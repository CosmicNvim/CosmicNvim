local config = require('cosmic.config')
require('cosmic.lsp.providers')
require('cosmic.lsp.diagnostics').init()

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})

if config.lsp and config.lsp.format_on_save then
  vim.cmd([[
     autocmd BufWritePre * lua vim.lsp.buf.formatting()
  ]])
end
