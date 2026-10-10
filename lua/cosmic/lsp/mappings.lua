local utils = require('cosmic.utils')
local lsp_utils = require('cosmic.utils.lsp')
local M = {}

---@param count integer
local function jump_diagnostic(count)
  vim.diagnostic.jump({
    count = count,
    on_jump = function(diagnostic, bufnr)
      if diagnostic == nil then
        return
      end

      vim.diagnostic.open_float({
        bufnr = bufnr,
        focus = false,
        scope = 'cursor',
      })
    end,
  })
end

local function format()
  local ok, conform = pcall(require, 'conform')
  if ok then
    conform.format({ lsp_format = 'fallback' })
  else
    vim.lsp.buf.format()
  end
end

-- Mappings. gd, gr and the other go-to mappings come from Snacks; Neovim maps K to hover.
function M.init(client, bufnr)
  local buf_map = utils.create_buf_map(bufnr)

  -- diagnostics
  buf_map('n', '[g', function()
    jump_diagnostic(-1)
  end, { desc = 'Prev diagnostic' })
  buf_map('n', ']g', function()
    jump_diagnostic(1)
  end, { desc = 'Next diagnostic' })
  buf_map('n', 'ge', function()
    vim.diagnostic.open_float({ scope = 'line' })
  end, { desc = 'Show current line diagnostic' })

  -- inlay hints
  if client:supports_method('textDocument/inlayHint') then
    buf_map('n', '<leader>lh', lsp_utils.toggle_inlay_hints, { desc = 'Toggle inlay hints for buffer' })
  end

  -- rename, code actions and formatting, through cosmic-ui's UI when it is enabled
  if require('lazy.core.config').plugins['cosmic-ui'] then
    buf_map('n', 'gn', function()
      require('cosmic-ui').rename.open()
    end, { desc = 'Rename' })
    buf_map('n', '<leader>la', function()
      require('cosmic-ui').codeactions.open()
    end, { desc = 'Code actions' })
    buf_map('v', '<leader>la', function()
      require('cosmic-ui').codeactions.range()
    end, { desc = 'Range code actions' })
    buf_map('n', '<leader>lf', function()
      require('cosmic-ui').formatters.format()
    end, { desc = 'Format' })
    buf_map('n', '<leader>ltx', function()
      require('cosmic-ui').formatters.open()
    end, { desc = 'Open formatters toggle' })
  else
    buf_map('n', 'gn', vim.lsp.buf.rename, { desc = 'Rename' })
    buf_map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { desc = 'Code actions' })
    buf_map('n', '<leader>lf', format, { desc = 'Format' })
  end
  buf_map('v', '<leader>lf', format, { desc = 'Range format' })

  -- lsp workspace
  buf_map('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
  buf_map('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
  buf_map('n', '<leader>lwl', function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, { desc = 'Show workspace folders' })
end

return M
