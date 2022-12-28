local user_config = require('cosmic.core.user')
return {
  'tpope/vim-fugitive',
  opt = true,
  cmd = 'Git',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'fugitive'),
}
