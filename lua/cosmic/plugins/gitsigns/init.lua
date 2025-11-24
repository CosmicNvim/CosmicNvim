local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { { 'nvim-lua/plenary.nvim', lazy = true } },
  event = 'VeryLazy',
  opts = {
    preview_config = {
      -- Options passed to nvim_open_win
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local map = u.create_buf_map(bufnr, {
        noremap = true
      })
      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.nav_hunk('next')
        end)
        return '<Ignore>'
      end, {
        expr = true,
        desc = 'Next git hunk',
      })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.nav_hunk('prev')
        end)
        return '<Ignore>'
      end, {
        expr = true,
        desc = 'Prev git hunk',
      })

      -- Actions
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, {
        desc = 'Stage hunk selection',
      })
      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, {
        desc = 'Reset hunk selection',
      })

      map('n', '<leader>kgS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>kgR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', 'B', function()
        gs.blame_line({ full = true })
      end, {
        desc = 'Blame line',
      })
      map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'Toggle blame current line' })

      --[[ -- Text object ]]
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end,
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
}
