local user_config = require('cosmic.core.user')
return {
  'folke/which-key.nvim',
  config = function()
    local wk = require('which-key')
    wk.setup({
      win = {
        border = user_config.border,
        wo = {
          winblend = 20,
        },
        padding = { 3, 5 }, -- extra window padding [top/bottom, right/left]
      },
      layout = {
        height = { min = 10, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 8,
        align = 'center',
      },
    })

    wk.add({
      { '<leader>k', group = 'buffer' },
      { '<leader>c', group = 'quickfix' },
      { '<leader>f', group = 'find' },
      { '<leader>g', group = 'goto' },
      { '<leader>x', group = 'terminal' },
      { '<leader>l', group = 'lsp' },
      { '<leader>ld', group = 'diagnostics' },
      { '<leader>lt', group = 'toggle' },
      { '<leader>lw', group = 'workspace' },
      { '<leader>n', group = 'tree' },
      { '<leader>p', group = 'plugins' },
      { '<leader>s', group = 'session' },
      { '<leader>t', group = 'tab' },
      { '<leader>v', group = 'git' },
      { '<leader>vt', group = 'toggle' },
    })
  end,
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'which-key'),
}
