-- add LSP auto commands here
local lsp_utils = require('cosmic.utils.lsp')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('cosmic_lsp_attach_disable_format', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local function buf_set_option(name, value)
      vim.api.nvim_set_option_value(name, value, {
        buf = bufnr,
      })
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client == nil then
      return
    end

    if not lsp_utils.can_client_format_on_save(client) then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local user_config = require('cosmic.core.user')
    if user_config.lsp.inlay_hint and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- set up default mappings
    local lsp_mappings = require('cosmic.lsp.mappings')
    lsp_mappings.init(client, bufnr)
  end,
  desc = 'LSP: disable formatting for user specified lsps',
})
