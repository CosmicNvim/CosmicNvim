---@diagnostic disable: missing-fields
local defaults = require('cosmic.lsp.servers.defaults')
local can_format_on_save = require('cosmic.utils.lsp').can_client_format_on_save
---
---@type vim.lsp.ClientConfig
return {
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 1000,
    exit_timeout = 1500,
  },
  on_attach = function(client, bufnr)
    defaults.on_attach(client, bufnr)
    if can_format_on_save(client) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function(event)
          --[[ https://github.com/neovim/nvim-lspconfig/issues/3837#issuecomment-2901107052 ]]
          local namespace = vim.lsp.diagnostic.get_namespace(client.id, true)
          local diagnostics = vim.diagnostic.get(event.buf, { namespace = namespace })
          local eslint = function(formatter) return formatter.name == 'eslint' end
          if #diagnostics > 0 then vim.lsp.buf.format({ async = false, filter = eslint }) end
        end,
        group = defaults.augroup,
      })
    end
  end,
}
