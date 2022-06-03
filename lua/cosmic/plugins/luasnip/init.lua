local config = require('cosmic.core.user')
local ls = require('luasnip')
local u = require('cosmic.utils')

-- some shorthands...
--[[ local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node ]]

-- Every unspecified option will be set to the default.
ls.config.set_config(u.merge({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}, config.luasnip or {}))

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
