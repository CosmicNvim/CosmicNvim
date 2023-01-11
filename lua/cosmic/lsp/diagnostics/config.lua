local u = require('cosmic.utils')
local icons = require('cosmic.utils.icons')
local user_config = require('cosmic.core.user')

local function format_diagnostic(diagnostic)
  local icon = icons.error
  if diagnostic.severity == vim.diagnostic.severity.WARN then
    icon = icons.warn
  elseif diagnostic.severity == vim.diagnostic.severity.INFO then
    icon = icons.info
  elseif diagnostic.severity == vim.diagnostic.severity.HINT then
    icon = icons.hint
  end

  local message = string.format('%s %s', icon, diagnostic.message)
  if diagnostic.code and diagnostic.source then
    message = string.format('%s [%s][%s] %s', icon, diagnostic.source, diagnostic.code, diagnostic.message)
  elseif diagnostic.code or diagnostic.source then
    message = string.format('%s [%s] %s', icon, diagnostic.code or diagnostic.source, diagnostic.message)
  end

  return message .. ' '
end

local config = u.merge({
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = user_config.border,
    focusable = false,
    header = { icons.debug .. ' Diagnostics:', 'DiagnosticInfo' },
    scope = 'line',
    suffix = '',
    source = false,
    format = format_diagnostic,
  },
  virtual_text = {
    prefix = '',
    spacing = 2,
    source = false,
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
    format = format_diagnostic,
  },
}, user_config.diagnostic or {})

return config
