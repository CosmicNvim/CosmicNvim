local icons = require('cosmic.core.theme.icons')
local M = {}

function M.init()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = 'always',
      -- severity = 'error'
      -- prefix = '👾',
    },
    signs = true,
    severity_sort = true,
    float = {
      show_header = true,
      source = 'always',
    }
  })

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
end

function M.trouble()
  require('trouble').setup({
    mode = 'lsp_document_diagnostics', -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    signs = {
      error = icons.error .. ' ',
      warning = icons.warn .. ' ',
      hint = icons.hint .. ' ',
      information = icons.info .. ' ',
    },
  })
end

return M
