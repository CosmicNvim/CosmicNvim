-- Override Cosmic configuration options

-- You can require null-ls if needed
-- local null_ls = require('null-ls')

local config = {
  -- See :h cmp-usage
  autocomplete = {},

  -- See https://github.com/rmagatti/auto-session#%EF%B8%8F-configuration
  auto_session = {},

  -- See :h nvim_open_win for possible border options
  border = 'rounded',

  -- https://github.com/numToStr/Comment.nvim#configuration-optional
  comments = {},

  -- See https://github.com/CosmicNvim/cosmic-ui#%EF%B8%8F-configuration
  cosmic_ui = {},

  -- see :h vim.diagnostic.config for all diagnostic configuration options
  diagnostic = {},

  -- see :h gitsigns-usage
  gitsigns = {},

  -- lsp settings
  lsp = {

    -- true/false or table of filetypes {'.ts', '.js',}
    format_on_save = true,

    -- set to false to disable rename notification
    rename_notification = true,

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
  },

  -- See https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
  lsp_signature = {},

  -- See https://github.com/L3MON4D3/LuaSnip/blob/577045e9adf325e58f690f4d4b4a293f3dcec1b3/README.md#config
  luasnip = {},

  -- default statusline icon
  statusline = {
    main_icon = '★',
  },

  -- See :h telescope.setup
  telescope = {},

  -- theming, don't forget to run :CosmicReloadSync when changing themes
  -- 'catppuccin',
  -- 'dracula',
  -- 'enfocado',
  -- 'github',
  -- 'gruvbox',
  -- 'kanagawa',
  -- 'nightfox',
  -- 'nord',
  -- 'onedark',
  -- 'rose-pine',
  theme = 'tokyonight', -- don't define or set to nil, if you want to enable your own theme in cosmic/config/plugins.lua

  -- See https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
  todo_comments = {},

  -- See :h nvim-treesitter-quickstart
  treesitter = {},

  -- See :h notify.setup
  notify = {},

  -- See :h nvim-tree.setup
  nvim_tree = {},
}

return config
