local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'gbprod/none-ls-shellcheck.nvim',
  },
  config = function()
    local defaults = require('cosmic.lsp.providers.defaults')
    local null_ls = require('null-ls')
    local config_opts = u.merge(user_config.lsp.servers.null_ls or {}, {
      default_cosmic_sources = true,
    })
    if config_opts.default_cosmic_sources then
      local function get_user_config_sources()
        if not config_opts.add_sources then
          return {}
        end

        return config_opts.add_sources()
      end

      config_opts.sources = u.merge_list({
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.markdownlint,
        --[[ require('none-ls.diagnostics.eslint_d'), ]]
        --[[ require('none-ls.formatting.eslint_d'), ]]
        --[[ require('none-ls.code_actions.eslint_d'), ]]
        null_ls.builtins.formatting.prettierd.with({
          env = {
            PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
          },
          extra_filetypes = { 'astro' },
        }),
        null_ls.builtins.formatting.stylua,
      }, get_user_config_sources())
    end

    null_ls.setup(u.merge(defaults, config_opts))
  end,
  event = 'BufReadPre',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'null_ls'),
}
