local user_config = require('cosmic.core.user')
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['<C-j>'] = { 'actions.preview_scroll_down', mode = 'n' },
      ['<C-k>'] = { 'actions.preview_scroll_up', mode = 'n' },
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
      ['<ESC>'] = { 'actions.close', mode = 'n' },
    },
    float = {
      max_height = 70,
      max_width = 180,
    },
  },
  keys = {
    {
      '<leader>od',
      function()
        require('oil').toggle_float(vim.uv.cwd())
      end,
      desc = 'Current working directory',
    },
    {
      '<leader>of',
      function()
        require('oil').toggle_float()
      end,
      desc = 'Current file directory',
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'oil'),
}
