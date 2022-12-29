local default_on_attach = require('cosmic.lsp.providers.defaults').on_attach
local M = {}

function M.on_attach(client, bufnr)
  default_on_attach(client, bufnr)

  -- ts utils must be setup on "on_attach"
  require('cosmic.plugins.nvim-lsp-ts-utils.setup').setup(client)
end

return M
