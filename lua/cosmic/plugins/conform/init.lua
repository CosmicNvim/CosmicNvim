local js = require('cosmic.utils.js')
local lsp_utils = require('cosmic.utils.lsp')
local user_config = require('cosmic.core.user')

-- Fresh lists per filetype, so extending one filetype in user opts doesn't change the others.
local function web_formatters()
  return { 'oxfmt', 'prettierd', 'prettier' }
end

local function js_formatters()
  return { 'oxlint', 'eslint_d', 'oxfmt', 'prettierd', 'prettier' }
end

---@param linter 'eslint'|'oxlint'
local function uses_linter(linter)
  return function(_, ctx)
    return js.linters(ctx.dirname)[linter]
  end
end

---@param formatter 'oxfmt'|'prettier'
local function uses_formatter(formatter)
  return function(_, ctx)
    return js.formatter(ctx.dirname) == formatter
  end
end

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

  local enabled = {}
  for _, formatter in ipairs(status.conform.formatters) do
    if formatter.effective_enabled then
      enabled[formatter.name] = true
    end
  end

  -- cosmic-ui lists formatters alphabetically, so take the configured order from conform.
  local configured = require('conform').list_formatters(bufnr)
  local formatters = {}
  for _, formatter in ipairs(configured) do
    if enabled[formatter.name] then
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

  -- An explicit list skips per-filetype conform options such as stop_after_first,
  -- so only pass one when cosmic-ui has turned some formatters off.
  if #formatters < #configured then
    opts.formatters = formatters
  end
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
    -- Web formatters are picked per project by the conditions below: lint fixes first, then formatting.
    formatters_by_ft = {
      css = web_formatters(),
      go = { 'goimports', 'gofmt' },
      html = web_formatters(),
      javascript = js_formatters(),
      javascriptreact = js_formatters(),
      json = web_formatters(),
      lua = { 'stylua' },
      markdown = web_formatters(),
      scss = web_formatters(),
      typescript = js_formatters(),
      typescriptreact = js_formatters(),
      python = {
        -- To fix auto-fixable lint errors.
        'ruff_fix',
        -- To run the Ruff formatter.
        'ruff_format',
        -- To organize the imports.
        'ruff_organize_imports',
      },
    },
    formatters = {
      eslint_d = { condition = uses_linter('eslint') },
      oxlint = { condition = uses_linter('oxlint') },
      oxfmt = { condition = uses_formatter('oxfmt') },
      prettierd = { condition = uses_formatter('prettier') },
      -- Prettier projects use prettierd, falling back to plain prettier when prettierd isn't installed.
      prettier = {
        condition = function(self, ctx)
          return uses_formatter('prettier')(self, ctx) and vim.fn.executable('prettierd') == 0
        end,
      },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },

    format_on_save = format_on_save,
  },
}
