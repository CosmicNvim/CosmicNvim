local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  pre_save_cmds = { 'NvimTreeClose', 'cclose', 'lua vim.notify.dismiss()' },
  post_restore_cmds = { 'NvimTreeRefresh' },
  auto_session_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = false,
}

return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup(u.merge(defaults, user_config.auto_session or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'auto-session'),
}
