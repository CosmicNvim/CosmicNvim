local ok, theme = pcall(require, 'tokyonight.colors')
if not ok then
  return false
end

local themeColors = theme.setup()

local colors = {
  white = themeColors.fg_dark,
  bg = themeColors.bg,
  bg_highlight = themeColors.bg_highlight,
  blue = themeColors.blue,
  purple = themeColors.magenta,
  orange = themeColors.orange,
  trace = themeColors.orange,
  hint = themeColors.teal,
  red = themeColors.red,
  diffAdd = themeColors.git.add,
  diffModified = themeColors.git.change,
  diffDeleted = themeColors.git.delete,
  info = themeColors.green2,
  error = themeColors.magenta2,
  warn = themeColors.orange,
  floatBorder = themeColors.border_highlight,
  selection_caret = themeColors.purple,
}

return colors
