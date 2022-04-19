local palette = require('nightfox.palette').load('nightfox')
local spec = require('nightfox.spec').load('nightfox')

local colors = {
  white = palette.fg2,
  bg = palette.bg1,
  bg_highlight = palette.bg3,
  normal = palette.blue.base,
  insert = palette.cyan.base,
  command = palette.orange.base,
  visual = palette.magenta.base,
  replace = palette.red.base,
  diffAdd = spec.git.add,
  diffModified = spec.git.change,
  diffDeleted = spec.git.delete,
  trace = palette.orange.base,
  hint = palette.cyan.base,
  info = palette.green.bright,
  error = palette.magenta.bright,
  warn = palette.orange.base,
  floatBorder = palette.bg3,
  selection_caret = palette.pink.base,
}

return colors
