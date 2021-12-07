local theme = require('onedark.colors')

local colors = {
  white = theme.fg,
  bg = theme.bg3,
  bg_highlight = theme.bg3,
  normal = theme.green,
  insert = theme.cyan,
  command = theme.orange,
  visual = theme.purple,
  replace = theme.red,
  diffAdd = theme.green,
  diffModified = theme.orange,
  diffDeleted = theme.red,
  trace = theme.orange,
  hint = theme.cyan,
  info = theme.green,
  error = theme.red,
  warn = theme.orange,
  floatBorder = theme.bg3,
  selection_caret = theme.purple,
}
return colors
