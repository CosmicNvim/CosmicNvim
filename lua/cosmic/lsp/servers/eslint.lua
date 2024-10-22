local defaults = require('cosmic.lsp.servers.defaults')
local can_format_on_save = require('cosmic.utils.lsp').can_client_format_on_save
return {
  on_attach = function(client, bufnr)
    defaults.on_attach(client, bufnr)
    if can_format_on_save(client) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
        group = defaults.augroup,
      })
    end
  end,
}
