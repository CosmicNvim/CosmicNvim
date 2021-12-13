local defaults = require('cosmic.lsp.providers.defaults')
local config = require('cosmic.config')
local null_ls = require('null-ls')

local has_eslint_config = function(utils)
  return utils.root_has_file('.eslintrc')
    or utils.root_has_file('.eslintrc.json')
    or utils.root_has_file('.eslintrc.js')
    or utils.root_has_file('package.json')
    or utils.root_has_file('.eslintrc.cjs')
    or utils.root_has_file('.eslintrc.yaml')
    or utils.root_has_file('.eslintrc.yml')
end

local config_opts = config.lsp.servers.null_ls or {}

require('null-ls').setup(vim.tbl_deep_extend('force', {
  -- you must define at least one source for the plugin to work
  sources = {
    null_ls.builtins.code_actions.eslint_d.with({
      condition = has_eslint_config,
    }),
    null_ls.builtins.diagnostics.eslint_d.with({
      condition = has_eslint_config,
    }),
    null_ls.builtins.formatting.eslint_d.with({
      condition = has_eslint_config,
    }),
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua,
  },

}, defaults, config_opts or {}))
