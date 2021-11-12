local config = require('cosmic.config')
local colors = {}

if config.theme == 'tokyonight.nvim' then
  colors = require('cosmic.core.theme.integrated.tokyonight')
elseif config.theme == 'Catppuccino.nvim' then
  colors = require('cosmic.core.theme.integrated.catppuccin')
elseif config.theme == 'gruvbox.nvim' then
  colors = require('cosmic.core.theme.integrated.gruvbox')
elseif config.theme == 'nord.nvim' then
  colors = require('cosmic.core.theme.integrated.nord')
end

return colors
