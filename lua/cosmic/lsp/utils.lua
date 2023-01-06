local user_config = require('cosmic.core.user')
local M = {}

function M.format(bufnr)
  vim.lsp.buf.format({
    timeout_ms = user_config.lsp.format_timeout,
    -- check user config to see if we can format on save
    filter = function(client)
      return user_config.lsp.can_client_format(client)
    end,
    bufnr = bufnr or 0,
  })
end

return M
