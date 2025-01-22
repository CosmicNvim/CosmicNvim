local user_config = require('cosmic.core.user')

return {
  'windwp/nvim-autopairs',
  opts = {
    check_ts = true,
    ts_config = {
      lua = { 'string', 'source' },
      javascript = { 'string', 'template_string' },
    },
    disable_filetype = { 'TelescopePrompt', 'vim' },
    fast_wrap = {},
  },
  event = 'InsertEnter',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'autopairs'),
}
