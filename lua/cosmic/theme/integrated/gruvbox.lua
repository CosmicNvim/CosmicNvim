local theme = require('gruvbox.colors')
local convert = require('lush.hsl.convert')

local colors = {
  white = convert.hsl_to_hex(theme.light0_hard),
  bg = convert.hsl_to_hex(theme.dark0),
  bg_highlight = convert.hsl_to_hex(theme.dark1),
  normal = convert.hsl_to_hex(theme.neutral_yellow),
  insert = convert.hsl_to_hex(theme.neutral_green),
  command = convert.hsl_to_hex(theme.neutral_orange),
  visual = convert.hsl_to_hex(theme.neutral_purple),
  replace = convert.hsl_to_hex(theme.neutral_red),
  diffAdd = convert.hsl_to_hex(theme.neutral_green),
  diffModified = convert.hsl_to_hex(theme.neutral_orange),
  diffDeleted = convert.hsl_to_hex(theme.neutral_red),
  trace = convert.hsl_to_hex(theme.neutral_orange),
  hint = convert.hsl_to_hex(theme.neutral_blue),
  info = convert.hsl_to_hex(theme.neutral_green),
  error = convert.hsl_to_hex(theme.neutral_red),
  warn = convert.hsl_to_hex(theme.neutral_orange),
  floatBorder = convert.hsl_to_hex(theme.dark3),
  selection_caret = convert.hsl_to_hex(theme.neutral_blue),
}
return colors
