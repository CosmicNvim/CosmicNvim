local colors = require('cosmic.core.theme.colors')
local highlight = require('cosmic.utils').highlight
local g = vim.g

g.floaterm_width = 0.8
g.floaterm_height = 0.8
g.floaterm_title = '|👾 ($1/$2)|'
g.floaterm_opener = 'vsplit'
highlight('FloatermBorder', 'None', colors.floatBorder)
