local cosmic_ui = require('cosmic-ui')

-- set up lsp servers
require('cosmic.lsp.providers')
require('cosmic.lsp.diagnostics')

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = cosmic_ui.get_border(),
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = cosmic_ui.get_border(),
})
