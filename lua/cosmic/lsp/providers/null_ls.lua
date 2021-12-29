local utils = require('cosmic.utils')
local defaults = require('cosmic.lsp.providers.defaults')
local config = require('cosmic.config')
local null_ls = require('null-ls')

local config_opts = config.lsp.servers.null_ls or {}

require('null-ls').setup(utils.merge({
  -- you must define at least one source for the plugin to work
  sources = {
    null_ls.builtins.code_actions.eslint_d.with({
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.diagnostics.eslint_d.with({
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.eslint_d.with({
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.prettier.with({
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.gitsigns,
  },
}, defaults, config_opts or {}))
