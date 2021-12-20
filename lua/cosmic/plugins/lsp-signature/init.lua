local config = require('cosmic.config')

require('lsp_signature').setup(vim.tbl_deep_extend('force', {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = config.border,
  },
}, config.lsp_signature or {}))
