local icons = require('cosmic.theme.icons')
local config = require('cosmic.config')
local cosmic_ui = require('cosmic-ui')

-- set up LSP signs
local signs = {
  Error = icons.error .. ' ',
  Warn = icons.warn .. ' ',
  Hint = icons.hint .. ' ',
  Info = icons.info .. ' ',
}

local t = vim.fn.sign_getdefined('DiagnosticSignWarn')
if vim.tbl_isempty(t) then
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

-- set up vim.diagnostics
-- vim.diagnostic.config opts
vim.diagnostic.config(vim.tbl_deep_extend('force', {
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    header = false,
    source = 'always',
    border = cosmic_ui.get_border(),
  },
  virtual_text = {
    spacing = 4,
    source = 'always',
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
  },
}, config.diagnostic or {}))
