local config = require('cosmic.config')
local colors = {}

if config.theme == 'tokyonight.nvim' then
  colors = require('cosmic.core.theme.integrated.tokyonight')
elseif config.theme == 'Catppuccino.nvim' then
  colors = require('cosmic.core.theme.integrated.catppuccin')
elseif config.theme == 'gruvbox.nvim' then
  colors = require('cosmic.core.theme.integrated.gruvbox')
elseif config.theme == 'rose-pine' then
  colors = require('cosmic.core.theme.integrated.rosepine')
elseif config.theme == 'nord.nvim' then
  colors = require('cosmic.core.theme.integrated.nord')
end

if vim.tbl_isempty(colors) then
  return false
end

colors.notify_bg = 'Normal'
if config.theme == 'gruvbox.nvim' then
  colors.notify_bg = colors.bg
end

return colors
