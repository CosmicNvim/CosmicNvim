local config = require('cosmic.config')
local defaults = require('cosmic.lsp.providers.defaults')
local null_ls = require('null-ls')

local config_opts = config.lsp.servers.null_ls or {}
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
    null_ls.builtins.diagnostics.eslint_d.with({ -- eslint or eslint_d
      -- prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.code_actions.eslint_d.with({ -- eslint or eslint_d
      -- prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.prettierd.with({ -- prettier, eslint, eslint_d, or prettierd
      -- prefer_local = 'node_modules/.bin',
    }),
  },
}, config_opts or {}))

require('lspconfig')['null-ls'].setup(vim.tbl_deep_extend('force', defaults, config_opts.opts or {}))
