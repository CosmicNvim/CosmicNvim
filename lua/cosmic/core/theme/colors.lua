local config = require('cosmic.config')
local colors = {}
local mod = 'cosmic.core.theme.integrated.'
local supported_themes = {
  'tokyonight',
  'catppuccino',
  'gruvbox',
  'rose-pine',
  'nord',
}

for _, theme in pairs(supported_themes) do
  if theme == config.theme then
    colors = require(mod .. theme)
  end
end

if vim.tbl_isempty(colors) then
  return false
end

-- @TODO: move elsewhere
colors.notify_bg = 'Normal'
if config.theme == 'gruvbox' then
  colors.notify_bg = colors.bg
end

return colors
