require('auto-session').setup({
  pre_save_cmds = { 'NvimTreeClose', 'cclose', 'lua vim.notify.dismiss()' },
  auto_session_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = false,
})
