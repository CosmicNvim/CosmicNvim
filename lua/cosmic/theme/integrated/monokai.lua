local palette = require('monokai').classic;

local colors = {
  white = palette.white,
  bg = palette.base2,
  bg_highlight = palette.base1,
  normal = palette.aqua,
  insert = palette.green,
  command = palette.orange,
  visual = palette.yellow,
  replace = palette.red,
  diffAdd = palette.diff_add,
  diffModified = palette.diff_change,
  diffDeleted = palette.diff_remove,
  trace = palette.orange,
  hint = palette.aqua,
  info = palette.green,
  error = palette.red,
  warn = palette.orange,
  floatBorder = palette.border,
  selection_caret = palette.pink,
}

return colors

