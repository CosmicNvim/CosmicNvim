local theme = require('gruvbox.colors')

local colors = {
  white = theme.light0_hard,
  bg = theme.dark0,
  bg_highlight = theme.dark1,
  normal = theme.neutral_yellow,
  insert = theme.neutral_green,
  command = theme.neutral_orange,
  visual = theme.neutral_purple,
  replace = theme.neutral_red,
  diffAdd = theme.neutral_green,
  diffModified = theme.neutral_orange,
  diffDeleted = theme.neutral_red,
  trace = theme.neutral_orange,
  hint = theme.neutral_blue,
  info = theme.neutral_green,
  error = theme.neutral_red,
  warn = theme.neutral_orange,
  floatBorder = theme.dark3,
  selection_caret = theme.neutral_blue,
}
return colors
