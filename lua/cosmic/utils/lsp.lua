local user_config = require('cosmic.core.user')
local M = {}

-- global var for format on save
vim.g.format_on_save_enabled = true

--- Checks if user config allows lsp to format on save
--- @param client vim.lsp.Client  # the LSP client object
--- @return boolean               # true if formatting on save is allowed
function M.can_client_format_on_save(client)
  local server_config = user_config.lsp.servers[client.name]
  if type(server_config) == "table" and server_config.format_on_save == false then
    return false
  end
  return true
end

--- Get list of formatter names that will run for current buffer
--- @return string[]
local function get_conform_formatters()
  local formatters = {}
  local ok, conform = pcall(require, 'conform')
  if not ok then
    return formatters
  end

  for _, formatter in pairs(conform.list_formatters_to_run()) do
    table.insert(formatters, formatter.name)
  end

  table.sort(formatters)
  return formatters
end

--- Helper to build output string for formatters.
--- @param prefix string       Prefix prepended to message
--- @param msg string          Message to append to
--- @param formatters string[] List of formatter names
--- @return string             The combined message
local function append_formatters_to_str(prefix, msg, formatters)
  if #formatters > 0 then
    table.sort(formatters)
    msg = msg .. string.format('[%s] \n' .. table.concat(formatters, "\n"), prefix)
  else
    msg = msg .. string.format('[%s] \nNo formatters to toggle', prefix)
  end

  return msg
end

--- Notify user of formatters toggled
--- @param lsp_formatters string[]  List of lsp formatters
--- @return nil
local function notify_format_on_save(lsp_formatters)
  local msg = ''
  msg = append_formatters_to_str('LSP', msg, lsp_formatters)

  -- also notify about any conform formatters that are now toggled via global var
  local conform_formatters = get_conform_formatters()
  if #conform_formatters > 0 then
    msg = msg .. '\n\n'
    msg = append_formatters_to_str('Conform', msg, conform_formatters)
  end

  local subtitle = "Format on save: [disabled]\n\n"
  if vim.g.format_on_save_enabled then
    subtitle = "Format on save: [enabled]\n\n"
  end
  vim.notify(subtitle .. msg, "info", {
    title = "Format on save"
  })
end

--- Toggle formatting on save
--- @return nil
function M.toggle_format_on_save()
  vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled

  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
  })
  local lsp_formatters = {}

  for _, client in ipairs(clients) do
    if M.can_client_format_on_save(client) then
      client.server_capabilities.documentFormattingProvider = vim.g.format_on_save_enabled
      client.server_capabilities.documentRangeFormattingProvider = vim.g.format_on_save_enabled
      table.insert(lsp_formatters, client.name)
    end
  end

  table.sort(lsp_formatters)
  notify_format_on_save(lsp_formatters)
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
    return table.concat(client_names, ", ")
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
