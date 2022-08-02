local u = require('cosmic.utils')
local icons = require('cosmic.theme.icons')
local config = require('cosmic.core.user')

-- set up LSP signs
local signs = {
  Error = icons.error .. ' ',
  Warn = icons.warn .. ' ',
  Hint = icons.hint .. ' ',
  Info = icons.info .. ' ',
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

local function format(diagnostic)
  local icon = icons.error
  if diagnostic.severity == vim.diagnostic.severity.WARN then
    icon = icons.warn
  end

  if diagnostic.severity == vim.diagnostic.severity.HINT then
    icon = icons.hint
  end

  local message = string.format(' %s [%s][%s] %s', icon, diagnostic.code, diagnostic.source, diagnostic.message)
  return message
end

-- set up vim.diagnostics
-- vim.diagnostic.config opts
vim.diagnostic.config(u.merge({
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = config.border,
    focusable = false,
    header = { icons.debug .. ' Diagnostics:', 'Normal' },
    scope = 'line',
    source = false,
    format = format,
  },
  virtual_text = {
    prefix = '•',
    spacing = 2,
    source = false,
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
    format = format,
  },
}, config.diagnostic or {}))
