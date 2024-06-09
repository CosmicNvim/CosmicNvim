local user_config = require('cosmic.core.user')
local M = {}

M.format_on_save_disabled = false

function M.can_format_on_save(client)
  -- formatting enabled by default if server=true
  local user_server_config = user_config.lsp.servers[client.name]
  if user_server_config == true then
    return true
  end

  -- check config server settings
  if user_server_config then
    -- default to true if no format flag on server settings is set
    if user_server_config.format_on_save == nil then
      return true
    end

    -- check format flag on server settings
    return user_server_config.format_on_save == true
  end

  return true
end

function M.toggle_format_on_save()
  M.format_on_save_disabled = not M.format_on_save_disabled
  vim.notify(string.format('Format on save disabled: %s', M.format_on_save_disabled))
end

function M.buf_format(bufnr, timeout)
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

function M.buf_get_active_client_names(bufnr)
  local active_clients = vim.lsp.get_clients({
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
  })
  local client_names = {}
  for _, client in pairs(active_clients or {}) do
    table.insert(client_names, client.name)
  end

  if not vim.tbl_isempty(client_names) then
    table.sort(client_names)
  end
  return client_names
end

function M.buf_get_active_clients_str()
  local client_names = M.buf_get_active_client_names()
  local client_str = ''

  if #client_names < 1 then
    return
  end

  for i, client_name in ipairs(client_names) do
    client_str = client_str .. client_name
    if i < #client_names then
      client_str = client_str .. ', '
    end
  end

  return client_str
end

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
