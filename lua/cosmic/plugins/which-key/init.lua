local user_config = require('cosmic.core.user')
return {
  'folke/which-key.nvim',
  config = function()
    local wk = require('which-key')
    wk.setup(
      ---@class wk.Opts
      {
        preset = 'modern',
        win = {
          border = user_config.border,
          padding = { 3, 2, 3, 2 },
        },
        layout = {
          height = { min = 10, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 8,
          align = 'center',
        },
      }
    )

    wk.add({
      { '<leader>c', group = 'quickfix' },
      { '<leader>f', group = 'find' },
      { '<leader>g', group = 'git' },
      { '<leader>gh', group = 'hunks' },
      { '<leader>gt', group = 'toggle' },
      { '<leader>h', group = 'gitsigns' },
      { '<leader>ht', group = 'toggle' },
      { '<leader>k', group = 'buffer' },
      { '<leader>l', group = 'lsp' },
      { '<leader>ld', group = 'diagnostics' },
      { '<leader>lt', group = 'toggle' },
      { '<leader>lw', group = 'workspace' },
      { '<leader>n', group = 'notifications' },
      { '<leader>n', group = 'tree' },
      { '<leader>o', group = 'open' },
      { '<leader>p', group = 'lazy (plugins)' },
      { '<leader>s', group = 'session' },
      { '<leader>t', group = 'tab' },
      { '<leader>x', group = 'terminal' },
    })
  end,
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'which-key'),
}
