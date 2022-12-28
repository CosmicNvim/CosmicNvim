local user_config = require('cosmic.core.user')

return {
  'neovim/nvim-lspconfig',
  config = function()
    require('cosmic.lsp')
  end,
  dependencies = {
    { 'b0o/SchemaStore.nvim' },
    { 'williamboman/nvim-lsp-installer' },
    { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lspconfig'),
}
