local user_config = require('cosmic.core.user')
local g = vim.g
local title = vim.env.SHELL

return {
  'voldikss/vim-floaterm',
  keys = {
    { '<C-l>', '<cmd>FloatermToggle<cr>', desc = 'Floating Terminal' },
  },
  config = function()
    g.floaterm_width = 0.7
    g.floaterm_height = 0.8
    g.floaterm_title = '[' .. title .. ']:($1/$2)'
    g.floaterm_borderchars = '─│─│╭╮╯╰'
    g.floaterm_opener = 'vsplit'

    require('cosmic.plugins.terminal.mappings')
    require('cosmic.plugins.terminal.highlights')
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'terminal'),
}
