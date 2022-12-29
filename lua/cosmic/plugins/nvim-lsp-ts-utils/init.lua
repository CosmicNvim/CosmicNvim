local user_config = require('cosmic.core.user')

return {
  'jose-elias-alvarez/nvim-lsp-ts-utils',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lsp-ts-utils'),
}
