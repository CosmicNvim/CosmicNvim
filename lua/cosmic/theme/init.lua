local _, colors = pcall(require, 'cosmic.theme.colors')
if not colors then
  return
end
local highlight = require('cosmic.theme.utils').highlight
local get_highlight = require('cosmic.theme.utils').get_highlight
local set_highlight = require('cosmic.theme.utils').set_highlight

-- @TODO: can i get rid of this?
highlight('StatusLine', colors.statusline_bg, colors.statusline_bg)

local error_colors = get_highlight('DiagnosticError')
set_highlight(
  'DiagnosticErrorInv',
  vim.tbl_extend('force', error_colors, {
    guibg = error_colors.guifg,
    guifg = colors.statusline_bg,
  })
)

local warning_colors = get_highlight('DiagnosticWarn')
set_highlight(
  'DiagnosticWarnInv',
  vim.tbl_extend('force', warning_colors, {
    guibg = warning_colors.guifg,
    guifg = colors.statusline_bg,
  })
)

local hint_colors = get_highlight('DiagnosticHint')
set_highlight(
  'DiagnosticHintInv',
  vim.tbl_extend('force', hint_colors, {
    guibg = hint_colors.guifg,
    guifg = colors.statusline_bg,
  })
)

local info_colors = get_highlight('DiagnosticInfo')
set_highlight(
  'DiagnosticInfoInv',
  vim.tbl_extend('force', info_colors, {
    guibg = info_colors.guifg,
    guifg = colors.statusline_bg,
  })
)

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
