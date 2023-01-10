local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  config = function()
    require('gitsigns').setup(u.merge({
      signs = {
        add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      },
      preview_config = {
        -- Options passed to nvim_open_win
        border = user_config.border,
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = u.create_buf_map(bufnr)
        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
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
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, {
          expr = true,
          desc = 'Prev git hunk',
        })

        -- Actions
        map({ 'n', 'v' }, '<leader>vs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
        map({ 'n', 'v' }, '<leader>vr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
        map('n', '<leader>vS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>vu', gs.undo_stage_hunk, { desc = 'Under stage hunk' })
        map('n', '<leader>vR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>vp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>vb', function()
          gs.blame_line({ full = true })
        end, {
          desc = 'Blame line preview',
        })
        map('n', '<leader>vd', gs.diffthis, { desc = 'Diff line' })
        map('n', '<leader>vD', function()
          gs.diffthis('~')
        end, { desc = 'Diff project' })

        map('n', '<leader>vtb', gs.toggle_current_line_blame, { desc = 'Toggle blame (virtual text)' })
        map('n', '<leader>vtd', gs.toggle_deleted, { desc = 'Toggle deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
      end,
    }, user_config.plugins.gitsigns or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
}
