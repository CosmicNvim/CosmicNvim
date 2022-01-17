local config = require('github-theme.config')
local theme_colors = require('github-theme.colors').setup(config.schema)

local colors = {
  white = theme_colors.bright_white,
  bg = theme_colors.bg,
  bg_highlight = theme_colors.bg_highlight,
  normal = theme_colors.blue,
  insert = theme_colors.green,
  command = theme_colors.bright_magenta,
  visual = theme_colors.yellow,
  replace = theme_colors.red,
  diffAdd = theme_colors.git.add,
  diffModified = theme_colors.git.change,
  diffDeleted = theme_colors.git.delete,
  trace = theme_colors.orange,
  hint = theme_colors.hint,
  info = theme_colors.info,
  error = theme_colors.error,
  warn = theme_colors.warn,
  floatBorder = theme_colors.border,
  selection_caret = theme_colors.magenta,
}

return colors
