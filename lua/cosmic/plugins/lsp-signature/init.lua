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
    }, user_config.plugins.lsp_signature or {}))
  end,
  enabled = false,
}
