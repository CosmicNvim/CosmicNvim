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

  if client.supports_method('textDocument/formatting') then
    -- set up :LspFormat for clients that are capable
    vim.cmd(string.format("command! LspFormat lua require('cosmic.utils.lsp').format(%s)", bufnr))

    -- set up auto format on save
    if user_config.lsp.format_on_save then
      -- check user config to see if we can format on save
      -- collect filetype(s) from user config
      local filetype_pattern = ''
      if vim.tbl_islist(user_config.lsp.format_on_save) then
        for _, ft in pairs(user_config.lsp.format_on_save) do
          filetype_pattern = filetype_pattern .. '*' .. ft
        end
      else -- any filetype if none set
        filetype_pattern = '*'
      end

      vim.api.nvim_clear_autocmds({
        group = group,
        buffer = bufnr,
      })
      -- autocommand for format on save with specified filetype(s)
      vim.api.nvim_create_autocmd(string.format('BufWritePre %s', filetype_pattern), {
        callback = function()
          require('cosmic.utils.lsp').format(bufnr)
        end,
        buffer = bufnr,
        group = group,
      })
    end
  end

  -- set up default mappings
  require('cosmic.lsp.mappings').init(client, bufnr)

  -- set up any additional mappings/overrides from user config
  for _, callback in pairs(user_config.lsp.on_attach_mappings) do
    callback(client, bufnr)
  end
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
