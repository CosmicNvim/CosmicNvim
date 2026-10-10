local user_config = require('cosmic.core.user')
local M = {}

--- Checks if user config allows this LSP client to format at all.
---@param client vim.lsp.Client
---@return boolean
function M.can_client_format(client)
  return not user_config.lsp.formatting_disabled[client.name]
end

--- Checks if user config allows this LSP client to format on save.
---@param client vim.lsp.Client
---@return boolean
function M.can_client_format_on_save(client)
  return M.can_client_format(client) and not user_config.lsp.format_on_save_disabled[client.name]
end

--- Toggle inlay hints for the current buffer
function M.toggle_inlay_hints()
  local filter = { bufnr = vim.api.nvim_get_current_buf() }
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
end

return M
