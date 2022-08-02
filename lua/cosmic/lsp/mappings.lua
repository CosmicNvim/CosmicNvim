local map = require('cosmic.utils').map
local M = {}

-- Mappings.
function M.init(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local function set_keymap(mode, lhs, rhs)
    map(mode, lhs, rhs, {
      buffer = bufnr,
    })
  end

  set_keymap('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')
  set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  set_keymap('n', 'gi', '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')
  set_keymap('n', 'gt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>')
  set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
  set_keymap('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')

  -- diagnostics
  set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "line", })<cr>')
  set_keymap('n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')

  -- hover
  set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

  -- code actions
  set_keymap('n', '<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
  set_keymap('v', '<leader>ga', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')

  -- formatting
  set_keymap('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<cr>')
  set_keymap('v', '<leader>gf', '<cmd>lua vim.lsp.buf.range_formatting()<cr>')

  -- signature help
  set_keymap('n', '<C-K>', '<cmd>lua require("lsp_signature").signature()<cr>')

  -- lsp workspace
  set_keymap('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
  set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  set_keymap(
    'n',
    '<leader>wl',
    '<cmd>lua require("cosmic.utils.logger"):log(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
  )

  if client.name == 'tsserver' then
    -- typescript helpers
    set_keymap('n', '<leader>gr', ':TSLspRenameFile<CR>')
    set_keymap('n', '<leader>go', ':TSLspOrganize<CR>')
    set_keymap('n', '<leader>gi', ':TSLspImportAll<CR>')
  end
end

return M
