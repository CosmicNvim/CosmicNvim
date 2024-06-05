local default_on_attach = require('cosmic.lsp.providers.defaults').on_attach
local M = {}

function M.on_attach(client, bufnr)
  default_on_attach(client, bufnr)
end

M.root_dir = function(fname)
  local util = require('lspconfig').util
  return util.root_pattern(
    '.git',
    'tsconfig.base.json',
    'tsconfig.json',
    'package.json',
    '.eslint.js',
    '.eslint.json',
    'eslint.config.js'
  )(fname)
end

return M
