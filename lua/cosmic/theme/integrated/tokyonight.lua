local theme = require('tokyonight.colors')
local themeColors = theme.setup()

local colors = {
  white = themeColors.fg_dark,
  bg = themeColors.bg,
  bg_highlight = themeColors.bg_highlight,
  normal = themeColors.blue,
  insert = themeColors.teal,
  command = themeColors.orange,
  visual = themeColors.magenta,
  replace = themeColors.red,
  diffAdd = themeColors.git.add,
  diffModified = themeColors.git.change,
  diffDeleted = themeColors.git.delete,
  trace = themeColors.orange,
  hint = themeColors.teal,
  info = themeColors.green2,
  error = themeColors.magenta2,
  warn = themeColors.orange,
  floatBorder = themeColors.border_highlight,
  selection_caret = themeColors.purple,
}

return colors
