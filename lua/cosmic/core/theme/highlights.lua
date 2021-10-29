local _, colors = pcall(require, 'cosmic.core.theme.colors')
if not colors then
  return
end
local highlight = require('cosmic.utils').highlight

-- diagnostic virtual text highlights
highlight('DiagnosticVirtualTextError', 'None', colors.error)
highlight('DiagnosticVirtualTextWarn', 'None', colors.warn)
highlight('DiagnosticVirtualTextInfo', 'None', colors.info)
highlight('DiagnosticVirtualTextHint', 'None', colors.hint)

-- diagnostics highlight
highlight('DiagnosticError', 'None', colors.error)
highlight('DiagnosticWarn', 'None', colors.warn)
highlight('DiagnosticInfo', 'None', colors.info)
highlight('DiagnosticHint', 'None', colors.hint)

highlight('Error', 'None', colors.error)
highlight('ErrorMsg', 'None', colors.error)
highlight('WarningMsg', 'None', colors.warn)

-- legacy diagnostics highlight
highlight('LspDiagnosticsError', 'None', colors.error)
highlight('LspDiagnosticsWarning', 'None', colors.warn)
highlight('LspDiagnosticsInformation', 'None', colors.info)
highlight('LspDiagnosticsHint', 'None', colors.hint)

highlight('LspDiagnosticsSignError', 'None', colors.error)
highlight('LspDiagnosticsSignWarning', 'None', colors.warn)
highlight('LspDiagnosticsSignInformation', 'None', colors.info)
highlight('LspDiagnosticsSignHint', 'None', colors.hint)

-- signature highlight color
highlight('LspSignatureActiveParameter', 'None', colors.orange)

-- currently not working?
highlight('TelescopeSelectionCaret', 'None', colors.selection_caret)

-- autocomplete highlights
highlight('CmpItemAbbrDeprecated', 'None', colors.warn)

-- notification highlights
highlight('NotifyINFOBorder', nil, colors.hint)
highlight('NotifyINFOTitle', nil, colors.hint)
highlight('NotifyINFOIcon', nil, colors.hint)
highlight('NotifyWARNBorder', nil, colors.warn)
highlight('NotifyWARNTitle', nil, colors.warn)
highlight('NotifyWARNIcon', nil, colors.warn)
highlight('NotifyERRORBorder', nil, colors.error)
highlight('NotifyERRORTitle', nil, colors.error)
highlight('NotifyERRORIcon', nil, colors.error)
highlight('NotifyTRACEBorder', nil, colors.trace)
highlight('NotifyTRACETitle', nil, colors.trace)
highlight('NotifyTRACEIcon', nil, colors.trace)

-- terminal highlight
highlight('FloatermBorder', 'None', colors.floatBorder)

vim.cmd([[
highlight clear NormalFloat
highlight link NormalFloat Normal
]])
