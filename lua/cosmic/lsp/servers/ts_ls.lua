---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
local M = {}

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
