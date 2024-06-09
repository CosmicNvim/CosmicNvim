local defaults = require('cosmic.lsp.providers.defaults')
return {
  on_attach = function(client, bufnr)
    defaults.on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
}
