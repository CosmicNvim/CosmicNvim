---@diagnostic disable: missing-fields
local defaults = require('cosmic.lsp.servers.defaults')
local can_format_on_save = require('cosmic.utils.lsp').can_client_format_on_save
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
        callback = function()
          if vim.g.format_on_save_enabled then
            vim.cmd('EslintFixAll')
          end
        end,
        group = defaults.augroup,
      })
    end
  end,
}
