local _, colors = pcall(require, 'cosmic.theme.colors')
if not colors then
  return
end
local highlight = require('cosmic.theme.highlight')

-- @TODO: can i get rid of this?
highlight('StatusLine', colors.statusline_bg, colors.statusline_bg)

-- @TODO: is all this work worth it?
--[[ -- diagnostic virtual text highlights
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
highlight('LspDiagnosticsSignHint', 'None', colors.hint) ]]

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

vim.cmd('hi FloatBorder guibg=None')
vim.cmd('hi! link FloatermBorder FloatBorder')
