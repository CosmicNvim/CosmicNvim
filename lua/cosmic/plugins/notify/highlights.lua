local _, colors = pcall(require, 'cosmic.theme.colors')
if not colors then
  return
end

local set_highlight = require('cosmic.theme.utils').set_highlight
-- notification highlights
set_highlight('NotifyINFOBorder', {
  guifg = colors.hint,
})
set_highlight('NotifyINFOTitle', {
  guifg = colors.hint,
})
set_highlight('NotifyINFOIcon', {
  guifg = colors.hint,
})
set_highlight('NotifyWARNBorder', {
  guifg = colors.warn,
})
set_highlight('NotifyWARNTitle', {
  guifg = colors.warn,
})
set_highlight('NotifyWARNIcon', {
  guifg = colors.warn,
})
set_highlight('NotifyERRORBorder', {
  guifg = colors.error,
})
set_highlight('NotifyERRORTitle', {
  guifg = colors.error,
})
set_highlight('NotifyERRORIcon', {
  guifg = colors.error,
})
set_highlight('NotifyTRACEBorder', {
  guifg = colors.trace,
})
set_highlight('NotifyTRACETitle', {
  guifg = colors.trace,
})
set_highlight('NotifyTRACEIcon', {
  guifg = colors.trace,
})
