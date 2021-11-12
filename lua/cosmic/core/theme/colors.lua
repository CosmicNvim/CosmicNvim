local config = require('cosmic.config')
local colors = {}

if config.theme == 'tokyonight.nvim' then
  print('loading tokyonight colors')
  colors = require('cosmic.core.theme.integrated.tokyonight')
elseif config.theme == 'Catppuccino.nvim' then
  print('loading catpuuccino colors')
  colors = require('cosmic.core.theme.integrated.catppuccin')
elseif config.theme == 'gruvbox.nvim' then
  print('loading gruvbox colors')
  colors = require('cosmic.core.theme.integrated.gruvbox')
elseif config.theme == 'nord.nvim' then
  print('loading nord colors')
  colors = require('cosmic.core.theme.integrated.nord')
end

return colors
