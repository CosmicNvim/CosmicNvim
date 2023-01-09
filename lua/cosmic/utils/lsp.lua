local user_config = require('cosmic.core.user')
local M = {}

-- format current buffer w/user settings
function M.format(bufnr)
  vim.lsp.buf.format({
    timeout_ms = user_config.lsp.format_timeout,
    bufnr = bufnr or 0,
  })
end

function M.get_active_lsp_client_names()
  local active_clients = vim.lsp.get_active_clients()
  local client_names = {}
  for _, client in pairs(active_clients or {}) do
    local buf = vim.api.nvim_get_current_buf()
    -- only return attached buffers
    if vim.lsp.buf_is_attached(buf, client.id) then
      table.insert(client_names, client.name)
    end
  end

  if not vim.tbl_isempty(client_names) then
    table.sort(client_names)
  end
  return client_names
end

function M.get_lsp_status_str()
  local clients = M.get_active_lsp_client_names()
  local client_str = ''

  if #clients < 1 then
    return client_str
  end

  for i, client in ipairs(clients) do
    client_str = client_str .. client
    if i < #clients then
      client_str = client_str .. ', '
    end
  end

  if client_str:len() < 1 then
    return
  end

  return client_str
end

return M
