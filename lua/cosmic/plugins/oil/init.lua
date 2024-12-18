return {
  event = 'VeryLazy',
  'stevearc/oil.nvim',
  config = function()
    local map = require('cosmic.utils').set_keymap
    require('oil').setup(
      ---@module 'oil'
      ---@type oil.SetupOpts
      {
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
      }
    )

    map('n', '<leader>od', function()
      require('oil').toggle_float(vim.uv.cwd())
    end, {
      desc = 'Open current working directory',
    })

    map('n', '<leader>of', function()
      require('oil').toggle_float()
    end, {
      desc = 'Open current file directory',
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
