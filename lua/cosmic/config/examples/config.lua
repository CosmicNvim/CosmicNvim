-- Override Cosmic configuration options

-- You can require null-ls if needed
-- local null_ls = require('null-ls')

local config = {}

-- default statusline icon
config.statusline = {
  main_icon = '★',
}

-- See :h nvim-treesitter-quickstart
config.treesitter = {}

-- theming, don't forget to run :CosmicReloadSync when changing themes
-- 'catppuccin'
-- 'dracula'
-- 'enfocado'
-- 'gruvbox'
-- 'nightfox'
-- 'nord'
-- 'onedark'
-- 'rose-pine'
config.theme = 'tokyonight' -- don't define or set to nil, if you want to enable your own theme in cosmic/config/plugins.lua

-- lsp settings
config.lsp = {

  -- true/false or table of filetypes {'.ts', '.js',}
  format_on_save = true,

  -- set to false to disable rename notification
  rename_notification = true,

  -- see :h vim.diagnostic.config for all diagnostic configuration options
  -- see Cosmic defaults: lsp/diagnostics.lua
  diagnostic = {},

  servers = {

    -- enable non-default servers, use default lsp config
    -- check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers
    -- rust_analyzer = true,

    tsserver = {
      -- disable formatting (defaults to true)
      format = false,
      -- OR add/override server options
      opts = {
        on_attach = function(client, bufnr) end,
        flags = {
          debounce_text_changes = 150,
        },
      },
    },

    -- See Cosmic defaults lsp/providers/null_ls.lua
    null_ls = {},
  },

  -- See Cosmic defaults lsp/providers/tsserver.lua
  -- If adding additional sources, be sure to also copy the defaults that you would like to preserve from lsp/providers/null_ls.lua
  ts_utils = {},

  -- see Cosmic-UI settings
  hover = {},
  signature_help = {},
}

-- See https://github.com/rmagatti/auto-session#%EF%B8%8F-configuration
config.auto_session = {}

-- See https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
config.todo_comments = {}

-- See :h notify.setup
config.notify = {}

-- See :h nvim-tree.setup
config.nvim_tree = {}

-- See :h telescope.setup
config.telescope = {}

return config
