local colors = require('cosmic.core.theme.colors')
local highlight = require('cosmic.utils').highlight
local M = {}

function M.init()
  -- diagnostic colors
  -- sign colors
  highlight('LspDiagnosticsSignError', 'None', colors.error)
  highlight('LspDiagnosticsSignWarning', 'None', colors.warn)
  highlight('LspDiagnosticsSignInformation', 'None', colors.info)
  highlight('LspDiagnosticsSignHint', 'None', colors.hint)

  --highlight('DiagnosticUnderlineError', 'None', colors.error)
  --highlight('DiagnosticUnderlineWarning', 'None', colors.warn)
  --highlight('DiagnosticUnderlineInformation', 'None', colors.info)
  --highlight('DiagnosticUnderlineHint', 'None', colors.hint)

  -- legacy lsp colors
  highlight('LspDiagnosticsError', 'None', colors.error)
  highlight('LspDiagnosticsWarn', 'None', colors.warn)
  highlight('LspDiagnosticsInfo', 'None', colors.info)
  highlight('LspDiagnosticsHint', 'None', colors.hint)

  highlight('DiagnosticError', 'None', colors.error)
  highlight('DiagnosticWarn', 'None', colors.warn)
  highlight('DiagnosticInfo', 'None', colors.info)
  highlight('DiagnosticHint', 'None', colors.hint)

  highlight('Error', 'None', colors.error)
  highlight('ErrorMsg', 'None', colors.error)
  highlight('WarningMsg', 'None', colors.error)

  -- signature highlight color
  highlight('LspSignatureActiveParameter', 'None', colors.orange)

  -- currently not working
  highlight('TelescopeSelectionCaret', 'None', colors.selection_caret)

  -- needs to highlight after lsp start, why? idk
  vim.cmd([[
    highlight clear NormalFloat
    highlight link NormalFloat Normal
  ]])
end

return M
