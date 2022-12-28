local user_config = require('cosmic.core.user')
return {
  'williamboman/nvim-lsp-installer',
  config = function()
    require('cosmic.plugins.nvim-lsp-installer.config')
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lsp-installer'),
}
