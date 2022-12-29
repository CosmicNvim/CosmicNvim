local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'L3MON4D3/LuaSnip',
  config = function()
    local ls = require('luasnip')
    ls.config.set_config(u.merge({
      history = true,
      -- Update more often, :h events for more info.
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
    }, user_config.plugins.luasnip or {}))

    -- extend html snippets to react files
    require('luasnip').filetype_extend('javascriptreact', { 'html' })
    require('luasnip').filetype_extend('typescriptreact', { 'html' })

    -- load snippets (friendly-snippets)
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'luasnip'),
}
