local user_config = require('cosmic.core.user')
local M = {}

vim.g.format_on_save_enabled = true

function M.can_client_format_on_save(client)
  local cfg = user_config.lsp.servers[client.name]
  if type(cfg) == "table" and cfg.format_on_save == false then
    return false
  end
  return true
end

local function append_formatters_to_str(prefix, msg, formatters)
  if #formatters > 0 then
    table.sort(formatters)
    msg = msg .. string.format('[%s] \n' .. table.concat(formatters, "\n"), prefix)
  else
    msg = msg .. string.format('[%s] \nNo formatters to toggle', prefix)
  end

  return msg
end

local function notify_format_on_save(msg)
  local subtitle = "Format on save: [disabled]\n\n"
  if vim.g.format_on_save_enabled then
    subtitle = "Format on save: [enabled]\n\n"
  end
  vim.notify(subtitle .. msg, "info", {
    title = "Format on save"
  })
end

function M.get_conform_formatters()
  local ok, conform = pcall(require, 'conform')
  if not ok then
    return {}
  end

  local formatters = {}

  for _, formatter in pairs(conform.list_formatters_to_run()) do
    table.insert(formatters, formatter.name)
  end

  if #formatters > 0 then
    table.sort(formatters)
    return formatters
  end

  return {}
end

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

  local conform_formatters = M.get_conform_formatters()

  local msg = ''
  msg = append_formatters_to_str('LSP', msg, lsp_formatters)

  if #conform_formatters > 0 then
    msg = msg .. '\n\n'
    msg = append_formatters_to_str('Conform', msg, conform_formatters)
  end

  notify_format_on_save(msg)
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
