local user_config = require('cosmic.core.user')
local utils = require('cosmic.utils')

return {
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  init = function()
    user_config.lsp.add_on_attach_mapping(function(client, bufnr)
      if client.name == 'tsserver' then
        local buf_map = utils.create_buf_map(bufnr)
        -- typescript helpers
        buf_map('n', '<leader>lr', ':TSLspRenameFile<CR>', { desc = 'Rename file' })
        buf_map('n', '<leader>lo', ':TSLspOrganize<CR>', { desc = 'Organize imports' })
        buf_map('n', '<leader>li', ':TSLspImportAll<CR>', { desc = 'Import All' })
      end
    end)
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lsp-ts-utils'),
}
