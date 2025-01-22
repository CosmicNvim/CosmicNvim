local user_config = require('cosmic.core.user')
local utils = require('cosmic.utils')

return {
  'CosmicNvim/cosmic-ui',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    border_style = 'rounded',
  },
  init = function()
    user_config.lsp.add_on_attach_mapping(function(client, bufnr)
      local buf_map = utils.create_buf_map(bufnr)

      buf_map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>', { desc = 'Rename' })
      buf_map('n', '<leader>la', '<cmd>lua require("cosmic-ui").code_actions()<cr>', { desc = 'Code Actions' })
      buf_map(
        'v',
        '<leader>la',
        '<cmd>lua require("cosmic-ui").range_code_actions()<cr>',
        { desc = 'Range Code Actions' }
      )
    end)
  end,
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'cosmic-ui'),
}
