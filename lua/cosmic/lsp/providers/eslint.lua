local default_on_attach = require('cosmic.lsp.providers.defaults').on_attach
return {
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,

  settings = {
    -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
    workingDirectories = { mode = 'auto' },
    -- allows to use flat config format
    --[[ experimental = { ]]
    --[[ useFlatConfig = true, ]]
    --[[ }, ]]
  },
}
