local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'lewis6991/gitsigns.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  config = function()
    local gs = require('gitsigns')
    gs.setup(u.merge({
      --[[ signs = { ]]
      --[[   add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' }, ]]
      --[[   change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' }, ]]
      --[[   delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' }, ]]
      --[[   topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' }, ]]
      --[[   changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' }, ]]
      --[[ }, ]]
      preview_config = {
        -- Options passed to nvim_open_win
        border = user_config.border,
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local map = u.create_buf_map(bufnr)
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
        map('n', '<leader>ghs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>ghr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>ghs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, {
          desc = 'Stage hunk selection',
        })
        map('v', '<leader>gr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, {
          desc = 'Reset hunk selection',
        })
        map('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>gb', function()
          gs.blame_line({ full = true })
        end, {
          desc = 'Blame line',
        })
        map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'Toggle blame current line' })
        map('n', '<leader>gd', gs.diffthis, { desc = 'Diff buffer' })
        map('n', '<leader>gD', function()
          gs.diffthis('~')
        end, { desc = 'Diff project' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle delete' })

        --[[ -- Text object ]]
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
      end,
    }, user_config.plugins.gitsigns or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
}
