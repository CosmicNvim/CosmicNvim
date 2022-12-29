local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  pre_save_cmds = { 'NvimTreeClose', 'cclose', 'lua vim.notify.dismiss()' },
  auto_session_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = false,
  auto_session_use_git_branch = true,
}

return {
  'rmagatti/auto-session',
  lazy = false,
  config = function()
    require('auto-session').setup(u.merge(defaults, user_config.plugins.auto_session or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'auto-session'),
}
