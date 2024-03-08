local default_on_attach = require('cosmic.lsp.providers.defaults').on_attach
return {
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
}
