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

-- Mappings.
function M.init(client, bufnr)
  local buf_map = utils.create_buf_map(bufnr, {
    noremap = true,
  })

  --[[ buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { desc = 'Go to declaration' }) ]]
  -- Commented out mappings are controlled by Snacks
  --[[ buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Go to definition' }) ]]
  --[[ buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { desc = 'Go to implementation' }) ]]
  --[[ buf_map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { desc = 'Go to type definition' }) ]]
  --[[ buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = 'Go to reference' }) ]]

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

  -- hover
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = 'Show documentation' })

  -- inlay hints
  if client:supports_method('textDocument/inlayHint') then
    buf_map('n', '<leader>lh', lsp_utils.toggle_inlay_hints(), { desc = 'Toggle inlay hints for buffer' })
  end

  -- code actions
  buf_map('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename' })
  buf_map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code Actions' })
  buf_map('v', '<leader>la', function()
    vim.lsp.buf.code_action()
  end, { desc = 'Range Code Actions' })

  -- formatting
  if client:supports_method('textDocument/formatting') then
    buf_map('n', '<leader>lf', lsp_utils.format_buf, { desc = 'Format', noremap = false })
    buf_map('v', '<leader>lf', function()
      vim.lsp.buf.format()
    end, { desc = 'Range Format', noremap = false })
  end

  -- lsp workspace
  buf_map('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', { desc = 'Add workspace folder' })
  buf_map('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', {
    desc = 'Remove workspace folder',
  })
  buf_map('n', '<leader>lwl', function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, { desc = 'Show workspace folders' })
end

return M
