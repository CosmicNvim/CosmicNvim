local user_config = require('cosmic.core.user')
return {
  'b0o/SchemaStore.nvim',
  lazy = true,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'schemastore'),
}
