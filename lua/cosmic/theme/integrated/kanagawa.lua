local theme_colors = require('kanagawa.colors').setup()

local colors = {
  white = theme_colors.fujiWhite,
  bg = theme_colors.sumiInk0,
  bg_highlight = theme_colors.sumiInk2,
  normal = theme_colors.sumiInk4,
  insert = theme_colors.waveBlue2,
  command = theme_colors.boatYellow2,
  visual = theme_colors.dragonBlue,
  replace = theme_colors.autumnRed,
  diffAdd = theme_colors.autumnGreen,
  diffModified = theme_colors.autumnYellow,
  diffDeleted = theme_colors.autumnRed,
  trace = theme_colors.surimiOrange,
  hint = theme_colors.dragonBlue,
  info = theme_colors.waveAqua1,
  error = theme_colors.samuraiRed,
  warn = theme_colors.roninYellow,
  floatBorder = theme_colors.sumiInk4,
  selection_caret = theme_colors.oniViolet,
}

return colors
