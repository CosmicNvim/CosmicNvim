local default_on_attach = require('cosmic.lsp.providers.defaults').on_attach
local M = {}

function M.on_attach(client, bufnr)
  default_on_attach(client, bufnr)
end

return M
