local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'L3MON4D3/LuaSnip',
  config = function()
    local ls = require('luasnip')
    -- Every unspecified option will be set to the default.
    ls.config.set_config(u.merge({
      history = true,
      -- Update more often, :h events for more info.
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
    }, user_config.luasnip or {}))

    ls.snippets = {
      all = {},
      html = {},
    }

    -- enable html snippets in javascript/javascript(REACT)
    ls.snippets.javascript = ls.snippets.html
    ls.snippets.javascriptreact = ls.snippets.html
    ls.snippets.typescriptreact = ls.snippets.html

    -- You can also use lazy loading so you only get in memory snippets of languages you use
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'luasnip'),
}
