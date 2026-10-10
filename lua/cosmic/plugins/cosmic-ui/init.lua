-- Rename, code action and formatter mappings live in lua/cosmic/lsp/mappings.lua.
return {
  --[[ dir = '~/dev/cosmic-ui/', ]]
  'CosmicNvim/cosmic-ui',
  dependencies = {
    { 'MunifTanjim/nui.nvim', lazy = true },
  },
  opts = {
    notify_title = 'CosmicUI',

    rename = {
      enabled = true, -- optional (defaults to true when table exists)
    },

    codeactions = {
      enabled = true, -- optional (defaults to true when table exists)
    },

    formatters = {
      enabled = true, -- optional (defaults to true when table exists)
    },
  },
  event = 'VeryLazy',
}
