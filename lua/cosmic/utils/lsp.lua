local user_config = require('cosmic.core.user')
local M = {}

M.format_disabled_override = false

local function can_client_format(client)
  -- formatting enabled by default if server=true
  if user_config.lsp.servers[client.name] == true or client.name == 'null-ls' then
    return true
  end

  -- check config server settings
  if user_config.lsp.servers[client.name] then
    -- default to true if no format flag on server settings is set
    if user_config.lsp.servers[client.name].format == nil then
      return true
    end

    -- check format flag on server settings
    return (user_config.lsp.servers[client.name].format == true)
  end

  return true
end

function M.toggle_format_on_save()
  M.format_disabled_override = not M.format_disabled_override
  vim.notify(string.format('Format on save disabled: %s', M.format_disabled_override))
end

-- format current buffer w/user settings
function M.format(bufnr, timeout)
  if timeout == '' or timeout == nil then
    timeout = user_config.lsp.format_timeout
  else
    timeout = timeout * 1000
  end
  local filter = can_client_format
  if M.format_disabled_override then
    filter = function(client)
      return false
    end
  end
  vim.lsp.buf.format({
    timeout_ms = timeout,
    filter = filter,
    bufnr = bufnr or 0,
  })
end

function M.get_active_lsp_clients()
  local active_clients = vim.lsp.get_clients()
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

function M.get_active_clients_str()
  local clients = M.get_active_lsp_clients()
  local client_str = ''

  if #clients < 1 then
    return
  end

  for i, client in ipairs(clients) do
    client_str = client_str .. client
    if i < #clients then
      client_str = client_str .. ', '
    end
  end

  return client_str
end

function M.toggle_inlay_hints()
  local enabled = user_config.lsp.inlay_hint
  return function()
    enabled = not enabled
    vim.lsp.inlay_hint(vim.api.nvim_get_current_buf() or 0, enabled)
  end
end

return M
