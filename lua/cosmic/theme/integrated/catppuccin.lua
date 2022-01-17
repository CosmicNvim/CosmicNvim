local theme = require('catppuccin.core.color_palette')

local colors = {
  white = theme.white,
  bg = theme.gray2,
  bg_highlight = theme.black4,
  normal = theme.maroon,
  insert = theme.pink,
  command = theme.red,
  visual = theme.yellow,
  replace = theme.flamingo,
  diffAdd = theme.blue,
  diffModified = theme.teal,
  diffDeleted = theme.red,
  trace = theme.red,
  hint = theme.white,
  info = theme.teal,
  error = theme.flamingo,
  warn = theme.red,
  floatBorder = theme.black4,
  selection_caret = theme.maroon,
}

return colors
