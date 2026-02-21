local utils = require('cosmic.utils')

return {
  'CosmicNvim/cosmic-ui',
  dependencies = {
    { 'MunifTanjim/nui.nvim', lazy = true },
  },
  opts = {
    border_style = 'rounded',
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup('cosmic_lsp_attach_cosmic_ui_mappings', { clear = true }),
      pattern = 'CosmicLspAttach',
      callback = function(args)
        local buf_map = utils.create_buf_map(args.buf)

        buf_map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>', { desc = 'Rename' })
        buf_map('n', '<leader>la', '<cmd>lua require("cosmic-ui").code_actions()<cr>', { desc = 'Code Actions' })
        buf_map(
          'v',
          '<leader>la',
          '<cmd>lua require("cosmic-ui").range_code_actions()<cr>',
          { desc = 'Range Code Actions' }
        )
      end,
      desc = 'LSP: disable formatting for user specified lsps',
    })
  end,
  event = 'VeryLazy',
}
