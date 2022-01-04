local g = vim.g
local title = vim.env.SHELL

g.floaterm_width = 0.7
g.floaterm_height = 0.8
g.floaterm_title = '[' .. title .. ']:($1/$2)'
g.floaterm_borderchars = '─│─│╭╮╯╰'
g.floaterm_opener = 'vsplit'

require('cosmic.plugins.terminal.mappings')
require('cosmic.plugins.terminal.highlights')
