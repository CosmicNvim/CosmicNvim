local user_config = require('cosmic.core.user')
local utils = require('cosmic.utils')

return {
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  init = function()
    user_config.lsp.add_on_attach_mapping(function(client, bufnr)
      if client.name == 'tsserver' then
        local buf_map = utils.create_buf_map(bufnr)
        -- typescript helpers
        buf_map('n', '<leader>gr', ':TSLspRenameFile<CR>')
        buf_map('n', '<leader>go', ':TSLspOrganize<CR>')
        buf_map('n', '<leader>gi', ':TSLspImportAll<CR>')
      end
    end)
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lsp-ts-utils'),
}
