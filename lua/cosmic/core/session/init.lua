local config = require('cosmic.config')
local defaults = {
  pre_save_cmds = { 'NvimTreeClose', 'cclose', 'lua vim.notify.dismiss()' },
  auto_session_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = false,
}

require('auto-session').setup(vim.tbl_deep_extend('force', defaults, config.session or {}))
