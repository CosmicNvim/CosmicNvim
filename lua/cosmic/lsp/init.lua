local config = require('cosmic.core.user')

-- set up lsp servers
require('cosmic.lsp.providers')
require('cosmic.lsp.diagnostics')
require('cosmic.lsp.commands')

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = config.border,
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = config.border,
})
