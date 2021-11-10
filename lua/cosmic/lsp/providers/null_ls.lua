local config = require('cosmic.config')
local on_attach = require('cosmic.lsp.providers.defaults').on_attach
local null_ls = require('null-ls')

null_ls.config(vim.tbl_deep_extend('force', {
  -- you must define at least one source for the plugin to work
  sources = {
    null_ls.builtins.formatting.stylua.with({
      args = {
        '-s',
        '--quote-style',
        'AutoPreferSingle',
        '--indent-type',
        'Spaces',
        '--indent-width',
        '2',
        '-',
      },
    }),
    null_ls.builtins.code_actions.gitsigns,
  },
}, config.lsp.servers.null_ls))

require('lspconfig')['null-ls'].setup({
  on_attach = on_attach,
})
