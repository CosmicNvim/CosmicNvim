return {
  'rmagatti/auto-session',
  event = 'VimEnter',
  opts = {
    pre_save_cmds = { 'cclose' },
    enabled = true,
    auto_restore = true,
    auto_save = true,
    git_use_branch_name = true,
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
}
