local utils = require('cosmic.utils')

return {
  --[[ dir = '~/dev/cosmic-ui/', ]]
  'CosmicNvim/cosmic-ui',
  dependencies = {
    { 'MunifTanjim/nui.nvim', lazy = true },
  },
  opts = {
    notify_title = 'CosmicUI',

    rename = {
      enabled = true, -- optional (defaults to true when table exists)
    },

    codeactions = {
      enabled = true, -- optional (defaults to true when table exists)
    },

    formatters = {
      enabled = true, -- optional (defaults to true when table exists)
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('cosmic_lsp_attach_cosmic_ui_mappings', { clear = true }),
      pattern = 'CosmicLspAttach',
      callback = function(args)
        local buf_map = utils.create_buf_map(args.buf)

        buf_map('n', 'gn', function()
          require('cosmic-ui').rename.open()
        end, { desc = 'Rename' })

        buf_map('n', '<leader>la', function()
          require('cosmic-ui').codeactions.open()
        end, { desc = 'Code actions' })

        buf_map('v', '<leader>la', function()
          require('cosmic-ui').codeactions.range()
        end, { desc = 'Range codeactions' })

        buf_map('n', '<leader>lx', function()
          require('cosmic-ui').formatters.open()
        end, { silent = true })

        buf_map('n', '<leader>lf', function()
          require('cosmic-ui').formatters.format()
        end, { silent = true })
      end,
      desc = 'LSP: disable formatting for user specified lsps',
    })
  end,
  event = 'VeryLazy',
}
