local lsp_utils = require('cosmic.utils.lsp')
local user_config = require('cosmic.core.user')

---@param bufnr integer
---@return conform.FormatOpts|nil
local function format_on_save(bufnr)
  local opts = {
    timeout_ms = user_config.lsp.format_timeout,
    lsp_format = 'fallback',
    filter = lsp_utils.can_client_format_on_save,
  }

  -- Requiring cosmic-ui makes lazy.nvim load it, so its formatter toggles apply from the first save.
  local ok, cosmic_ui = pcall(require, 'cosmic-ui')
  if not (ok and cosmic_ui.is_setup and cosmic_ui.is_setup()) then
    return opts
  end

  local status = cosmic_ui.formatters.status({ scope = 'buffer', bufnr = bufnr })
  if not status then
    return opts
  end

  local formatters = {}
  for _, formatter in ipairs(status.conform.formatters) do
    if formatter.effective_enabled then
      table.insert(formatters, formatter.name)
    end
  end

  -- When no conform formatter will run, cosmic-ui marks the LSP clients that may format instead.
  local lsp_clients = {}
  for _, client in ipairs(status.lsp_clients) do
    if client.conform_fallback and client.conform_fallback.eligible then
      lsp_clients[client.id] = true
    end
  end

  if #formatters == 0 and vim.tbl_isempty(lsp_clients) then
    return nil
  end

  opts.formatters = formatters
  opts.filter = function(client)
    return lsp_clients[client.id] == true and lsp_utils.can_client_format_on_save(client)
  end
  return opts
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      css = { 'oxfmt' },
      go = { 'goimports', 'gofmt' },
      html = { 'oxfmt' },
      javascript = { 'oxlint', 'oxfmt' },
      javascriptreact = { 'oxlint', 'oxfmt' },
      json = { 'oxfmt' },
      lua = { 'stylua' },
      markdown = { 'oxfmt' },
      scss = { 'oxfmt' },
      typescript = { 'oxlint', 'oxfmt' },
      typescriptreact = { 'oxlint', 'oxfmt' },
      python = {
        -- To fix auto-fixable lint errors.
        'ruff_fix',
        -- To run the Ruff formatter.
        'ruff_format',
        -- To organize the imports.
        'ruff_organize_imports',
      },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },

    format_on_save = format_on_save,
  },
}
