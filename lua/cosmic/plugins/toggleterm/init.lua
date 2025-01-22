local user_config = require('cosmic.core.user')
return {
  'akinsho/toggleterm.nvim',
  opts = {
    direction = 'float',
    float_opts = {
      border = user_config.border,
    },
    highlights = {
      FloatBorder = {
        link = 'FloatBorder',
      },
    },
  },
  cmd = { 'ToggleTerm' },
  keys = {
    {
      '<leader>xx',
      ':ToggleTerm<CR>',
      desc = 'Toggle Terminal',
    },
    {
      '<leader>xn',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local terminal = Terminal:new()
        terminal:toggle()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>fx',
      ':TermSelect<CR>',
      desc = 'Find open terminal',
    },
    {
      '<leader>xr',
      ':ToggleTermSetName<CR>',
      desc = 'Rename terminal',
    },
  },
}
