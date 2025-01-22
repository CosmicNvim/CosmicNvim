local user_config = require('cosmic.core.user')

return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    pre_save_cmds = { 'cclose' },
    auto_session_enabled = true,
    auto_restore_enabled = true,
    auto_save_enabled = true,
    use_git_branch = true,
  },
  keys = {
    {
      '<leader>sl',
      '<cmd>silent RestoreSession<cr>',
      desc = 'Restore session',
    },
    {
      '<leader>ss',
      '<cmd>SaveSession<cr>',
      desc = 'Save session',
    },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'auto-session'),
}
