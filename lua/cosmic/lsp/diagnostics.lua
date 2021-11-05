local config = require('cosmic.config')
local icons = require('cosmic.core.theme.icons')

local defaults = {
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    show_header = false,
    source = 'always',
    border = 'single',
  },
  virtual_text = {
    spacing = 4,
    source = 'always',
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
    -- todo: icons for diagnostics?
    --[[ format = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            return ('E: %s'):format(diagnostic.message)
          end
          return diagnostic.message
        end, ]]
  },
}

local opts = vim.tbl_deep_extend('force', defaults, config.lsp.diagnostic or {})

vim.diagnostic.config(opts)

local function do_diagnostic_signs()
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
end

local function do_legacy_diagnostic_signs()
  local signs = {
    Error = icons.error .. ' ',
    Warning = icons.warn .. ' ',
    Hint = icons.hint .. ' ',
    Information = icons.info .. ' ',
  }
  local h = vim.fn.sign_getdefined('LspDiagnosticsSignWarn')
  if vim.tbl_isempty(h) then
    for type, icon in pairs(signs) do
      local hl = 'LspDiagnosticsSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
  end
end

do_diagnostic_signs()
do_legacy_diagnostic_signs()
