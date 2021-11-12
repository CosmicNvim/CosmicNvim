local config = require('cosmic.config')
local colors = {}

if config.theme == 'tokyonight.nvim' then
  local theme = require('tokyonight.colors')
  local themeColors = theme.setup()

  colors = {
    white = themeColors.fg_dark,
    bg = themeColors.bg,
    bg_highlight = themeColors.bg_highlight,
    bg_dark = themeColors.bg_dark,
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
elseif config.theme == 'catppuccin' then
  local theme = require('catppuccin.core.color_palette')

  colors = {
    white = theme.catppuccin0,
    bg = theme.catppuccin12,
    bg_highlight = theme.catppuccin15,
    bg_dark = theme.catppuccin14,
    normal = theme.catppuccin3,
    insert = theme.catppuccin4,
    command = theme.catppuccin5,
    visual = theme.catppuccin8,
    replace = theme.catppuccin2,
    diffAdd = theme.catppuccin9,
    diffModified = theme.catppuccin7,
    diffDeleted = theme.catppuccin5,
    trace = theme.catppuccin5,
    hint = theme.catppuccin10,
    info = theme.catppuccin7,
    error = theme.catppuccin2,
    warn = theme.catppuccin5,
    floatBorder = theme.catppuccin12,
    selection_caret = theme.catppuccin3,
  }
  --[[ local color_palette = {
	catppuccin0 = "#F0F0F5",		-- Ghost White
	catppuccin1 = "#1B1624",		-- Xiketic
	catppuccin2 = "#EA31B5",		-- Fashion Fuchsia
	catppuccin3 = "#AE9AD6",		-- Blue Shell
	catppuccin4 = "#F0A8E4",		-- Orchid Crayola
	catppuccin5 = "#E28D8D",		-- New York Pink
	catppuccin6 = "#E7A988",		-- Tumbleweed
	catppuccin7 = "#ADD692",		-- Granny Smith Apple
	catppuccin8 = "#F0DC89",		-- Megium Champagne
	catppuccin9 = "#84A5CB",		-- Cerulean Frost
	catppuccin10 = "#B9C4E3",		-- Periwinkle Crayola
	catppuccin11 = "#6F6A8A",		-- Rhythm
	catppuccin12 = "#3e4058",		-- Independence
	catppuccin13 = "#0E0C13",		-- Xiketic
	catppuccin14 = "#221E2F",		-- Raisin Black
	catppuccin15 = "#312C44",		-- Space Cadet
} ]]
end

return colors
