local M = {}
local augroup_name = 'CosmicNvimLspFormat'
local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')
local lsp_utils = require('cosmic.utils.lsp')
local lsp_mappings = require('cosmic.lsp.mappings')

M.augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })

function M.on_attach(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_set_option_value(name, value, {
      buf = bufnr,
    })
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if user_config.lsp.inlay_hint and client.supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client.supports_method('textDocument/formatting') then
    -- set up :LspFormat for clients that are capable
    vim.cmd(
      string.format("command! -nargs=? LspFormat lua require('cosmic.utils.lsp').buf_format(%s, <q-args>)", bufnr)
    )

    -- set up auto format on save
    vim.api.nvim_clear_autocmds({
      group = M.augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        if not lsp_utils.format_on_save_disabled then
          vim.lsp.buf.format({
            timeout_ms = user_config.lsp.format_timeout,
            bufnr = bufnr,
            filter = function()
              return lsp_utils.can_format_on_save(client)
            end,
          })
        end
      end,
      buffer = bufnr,
      group = M.augroup,
    })
  end

  -- set up default mappings
  lsp_mappings.init(client, bufnr)

  -- set up any additional mappings/overrides from user config
  for _, callback in pairs(user_config.lsp.on_attach_mappings) do
    callback(client, bufnr)
  end
end

M.capabilities = u.merge(require('cmp_nvim_lsp').default_capabilities(), {
  -- See: https://github.com/neovim/neovim/issues/23291
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = false,
    },
  },
})

return M
