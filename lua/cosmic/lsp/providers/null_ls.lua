local utils = require('cosmic.utils')
local defaults = require('cosmic.lsp.providers.defaults')
local config = require('cosmic.config')
local null_ls = require('null-ls')

local config_opts = config.lsp.servers.null_ls or {}
local has_eslint_config = function(u)
  return u.root_has_file('.eslintrc')
    or u.root_has_file('.eslintrc.json')
    or u.root_has_file('.eslintrc.js')
    or u.root_has_file('package.json')
    or u.root_has_file('.eslintrc.cjs')
    or u.root_has_file('.eslintrc.yaml')
    or u.root_has_file('.eslintrc.yml')
end

require('null-ls').setup(utils.merge({
  sources = {
    null_ls.builtins.code_actions.eslint_d.with({
      condition = has_eslint_config,
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.diagnostics.eslint_d.with({
      condition = has_eslint_config,
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.eslint_d.with({
      condition = has_eslint_config,
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.prettier.with({
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.gitsigns,
  },
}, defaults, config_opts or {}))
