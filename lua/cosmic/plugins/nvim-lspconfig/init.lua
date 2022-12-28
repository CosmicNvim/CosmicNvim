local user_config = require('cosmic.core.user')

return {
  'neovim/nvim-lspconfig',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lspconfig'),
}
