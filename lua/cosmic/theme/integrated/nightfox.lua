local theme = require('nightfox.colors')
local themeColors = theme.init()

local colors = {
  white = themeColors.fg_alt,
  bg = themeColors.bg,
  bg_highlight = themeColors.bg_highlight,
  normal = themeColors.blue,
  insert = themeColors.cyan,
  command = themeColors.orange,
  visual = themeColors.magenta,
  replace = themeColors.red,
  diffAdd = themeColors.git.add,
  diffModified = themeColors.git.change,
  diffDeleted = themeColors.git.delete,
  trace = themeColors.orange,
  hint = themeColors.cyan,
  info = themeColors.green_br,
  error = themeColors.magenta_br,
  warn = themeColors.orange,
  floatBorder = themeColors.border_highlight,
  selection_caret = themeColors.pink,
}

return colors

