local config = require('cosmic.config')
local defaults = require('cosmic.lsp.providers.defaults')
local null_ls = require('null-ls')

local config_opts = config.lsp.servers.null_ls or {}
null_ls.config(vim.tbl_deep_extend('force', {
  -- you must define at least one source for the plugin to work
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua,
  },
}, config_opts or {}))

require('lspconfig')['null-ls'].setup(vim.tbl_deep_extend('force', defaults, config_opts.opts or {}))
