-- add LSP auto commands here
local lsp_utils = require('cosmic.utils.lsp')

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('cosmic_lsp_attach_disable_format', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if not lsp_utils.can_client_format_on_save(client) then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
  desc = 'LSP: disable formatting for user specified lsps',
})
