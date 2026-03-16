local user_config = require('cosmic.core.user')
local M = {}

--- Checks if user config allows lsp to format on save
--- @param client vim.lsp.Client  # the LSP client object
--- @return boolean               # true if formatting on save is allowed
function M.can_client_format_on_save(client)
  if user_config.lsp.format_on_save_disabled[client.name] then
    return false
  end
  return true
end

--- Format a buffer
--- @param bufnr number buffer to format
--- @param timeout number number in seconds to wait for formatting
function M.format_buf(bufnr, timeout)
  if timeout == '' or timeout == nil then
    timeout = user_config.lsp.format_timeout
  else
    timeout = timeout * 1000
  end
  vim.lsp.buf.format({
    timeout_ms = timeout,
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
  })
end

--- Get comma seperated string of active lsp clients for current buffer
--- @return string
function M.buf_get_active_clients_str()
  local active_clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
  })
  local client_names = {}

  for _, client in pairs(active_clients or {}) do
    table.insert(client_names, client.name)
  end

  if #client_names > 0 then
    table.sort(client_names)
    return table.concat(client_names, ', ')
  end

  return ''
end

--- Toggle inlay hints
--- @return nil
function M.toggle_inlay_hints()
  local enabled = user_config.lsp.inlay_hint
  return function()
    enabled = not enabled
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
      bufnr = vim.api.nvim_get_current_buf(),
    }))
  end
end

return M
