local user_config = require('cosmic.core.user')

return {
  'norcalli/nvim-colorizer.lua',
  opt = true,
  cmd = { 'ColorizerToggle' },
  config = function()
    require('colorizer').setup()
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'colorizer'),
}
