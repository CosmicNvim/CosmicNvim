local cosmic_ui = require('cosmic-ui')
local config = require('cosmic.config')

require('lsp_signature').setup(vim.tbl_deep_extend('force', {
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = cosmic_ui.get_border(),
  },
}, config.lsp_signature or {}))
