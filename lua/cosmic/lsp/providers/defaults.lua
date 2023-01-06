local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local M = {}
local augroup_name = 'CosmicNvimLspFormat'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local user_config = require('cosmic.core.user')

function M.on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentFormattingProvider then
    -- set up :LspFormat for clients that are capable
    vim.cmd(string.format("command! LspFormat lua require('cosmic.lsp.utils').format(%s)", bufnr))

    if user_config.lsp.format_on_save then
      -- collect filetype(s)
      local format_filetypes = ''
      if vim.tbl_islist(user_config.lsp.format_on_save) then
        for _, ft in pairs(user_config.lsp.format_on_save) do
          format_filetypes = format_filetypes .. '*' .. ft
        end
      else
        -- any filetype
        format_filetypes = '*'
      end

      -- autocommand for format on save with specified filetype(s)
      vim.api.nvim_create_autocmd(string.format('BufWritePre %s', format_filetypes), {
        callback = function()
          require('cosmic.lsp.utils').format(bufnr)
        end,
        group = group,
      })
    end
  end

  require('cosmic.lsp.mappings').init(client, bufnr)
end

M.capabilities = capabilities

M.root_dir = function(fname)
  local util = require('lspconfig').util
  return util.root_pattern('.git')(fname)
    or util.root_pattern('tsconfig.base.json')(fname)
    or util.root_pattern('package.json')(fname)
    or util.root_pattern('.eslintrc.js')(fname)
    or util.root_pattern('.eslintrc.json')(fname)
    or util.root_pattern('tsconfig.json')(fname)
end

return M
