local u = require('cosmic.utils')
local user_config = require('cosmic.core.user')
local M = {}

function M.on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('lsp_signature').on_attach(
    u.merge({
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    }, user_config.plugins.lsp_signature or {}),
    bufnr
  )

  require('cosmic.lsp.mappings').init(client, bufnr)
end

M.flags = {
  debounce_text_changes = 150,
}

M.capabilities = {}

M.root_dir = function(fname)
  local util = require('lspconfig').util
  return util.root_pattern('.git')(fname)
    or util.root_pattern('tsconfig.base.json')(fname)
    or util.root_pattern('package.json')(fname)
    or util.root_pattern('.eslintrc.js')(fname)
    or util.root_pattern('.eslintrc.json')(fname)
    or util.root_pattern('tsconfig.json')(fname)
end

M.autostart = true

M.single_file_support = true

return M
