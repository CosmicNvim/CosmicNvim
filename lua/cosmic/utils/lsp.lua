local user_config = require('cosmic.core.user')
local M = {}

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

-- format current buffer w/user settings
function M.format(bufnr)
  vim.lsp.buf.format({
    timeout_ms = user_config.lsp.format_timeout,
    filter = can_client_format,
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
