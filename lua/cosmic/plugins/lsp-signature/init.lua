local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'ray-x/lsp_signature.nvim',
  config = function()
    require('lsp_signature').setup(u.merge({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = user_config.border,
      },
    }, user_config.lsp_signature or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lsp_signature'),
}
