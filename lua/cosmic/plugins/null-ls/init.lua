local user_config = require('cosmic.core.user')

return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    require('cosmic.plugins.null-ls.config')
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'null_ls'),
}
