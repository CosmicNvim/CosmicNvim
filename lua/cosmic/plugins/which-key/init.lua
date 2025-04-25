local user_config = require('cosmic.core.user')
return {
  'folke/which-key.nvim',
  ---@class wk.Opts
  opts = {
    preset = 'modern',
    win = {
      padding = { 3, 2 },
    },
    layout = {
      width = { min = 20, max = 50 },
      spacing = 5,
      align = 'center',
    },
    ---@type wk.Spec
    spec = {
      { '<leader>c',  group = 'quickfix' },
      { '<leader>f',  group = 'find',          mode = { 'n', 'x' } },
      { '<leader>g',  group = 'git',           mode = { 'n', 'v' } },
      { '<leader>h',  group = 'git hunks' },
      { '<leader>gt', group = 'toggle' },
      { '<leader>h',  group = 'gitsigns' },
      { '<leader>ht', group = 'toggle' },
      { '<leader>k',  group = 'buffer' },
      { '<leader>l',  group = 'lsp',           mode = { 'n', 'v' } },
      { '<leader>ld', group = 'diagnostics' },
      { '<leader>lt', group = 'toggle' },
      { '<leader>lw', group = 'workspace' },
      { '<leader>n',  group = 'notifications' },
      { '<leader>n',  group = 'tree' },
      { '<leader>o',  group = 'open' },
      { '<leader>p',  group = 'lazy (plugins)' },
      { '<leader>s',  group = 'session' },
      { '<leader>t',  group = 'tab' },
      { '<leader>x',  group = 'terminal' },
    },
  },
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'which-key'),
}
