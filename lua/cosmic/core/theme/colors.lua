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
elseif config.theme == 'Catppuccino.nvim' then
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
elseif config.theme == 'nord.nvim' then
  local theme = require('nord.colors')
  local nord = {
    --16 colors
    nord0_gui = '#2E3440',
    nord1_gui = '#3B4252',
    nord2_gui = '#434C5E',
    nord3_gui = '#4C566A',
    nord3_gui_bright = '#616E88',
    nord4_gui = '#D8DEE9',
    nord5_gui = '#E5E9F0',
    nord6_gui = '#ECEFF4',
    nord7_gui = '#8FBCBB',
    nord8_gui = '#88C0D0',
    nord9_gui = '#81A1C1',
    nord10_gui = '#5E81AC',
    nord11_gui = '#BF616A',
    nord12_gui = '#D08770',
    nord13_gui = '#EBCB8B',
    nord14_gui = '#A3BE8C',
    nord15_gui = '#B48EAD',
    none = 'NONE',
  }
  colors = {
    white = theme.nord4_gui,
    bg = theme.nord2_gui,
    bg_highlight = theme.nord2_gui,
    bg_dark = theme.nord0_gui,
    normal = theme.nord9_gui,
    insert = theme.nord14_gui,
    command = theme.nord13_gui,
    visual = theme.nord15_gui,
    replace = theme.nord11_gui,
    diffAdd = theme.nord14_gui,
    diffModified = theme.nord13_gui,
    diffDeleted = theme.nord11_gui,
    trace = theme.nord13_gui,
    hint = theme.nord8_gui,
    info = theme.nord9_gui,
    error = theme.nord11_gui,
    warn = theme.nord13_gui,
    floatBorder = theme.nord3_gui,
    selection_caret = theme.nord9_gui,
  }
end

return colors
