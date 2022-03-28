-- Override Cosmic configuration options

-- You can require null-ls if needed
-- local null_ls = require('null-ls')

local config = {
  -- See https://github.com/rmagatti/auto-session#%EF%B8%8F-configuration
  auto_session = {},
  -- See :h nvim_open_win for possible border options
  border = 'rounded',
  -- https://github.com/numToStr/Comment.nvim#configuration-optional
  comment_nvim = {},
  -- See https://github.com/CosmicNvim/cosmic-ui#%EF%B8%8F-configuration
  cosmic_ui = {},
  -- See :h vim.diagnostic.config for all diagnostic configuration options
  diagnostic = {},
  -- See :h gitsigns-usage
  gitsigns = {},
  -- LSP settings
  lsp = {
    -- True/false or table of filetypes {'.ts', '.js',}
    format_on_save = true,
    -- Time in MS before format timeout
    format_timeout = 3000,
    -- Set to false to disable rename notification
    rename_notification = true,
    -- Enable non-default servers, use default lsp config
    -- Check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers
    servers = {
      -- Enable rust_analyzer
      rust_analyzer = true,

      -- Enable tsserver w/custom settings
      tsserver = {
        -- Disable formatting (defaults to true)
        format = false,
        -- OR add/override server options
        opts = {
          on_attach = function(client, bufnr) end,
          flags = {
            debounce_text_changes = 150,
          },
        },
      },
      -- See Cosmic defaults lsp/providers/null_ls.lua and https://github.com/jose-elias-alvarez/null-ls.nvim/
      -- If adding additional sources, be sure to also copy the defaults that you would like to preserve from lsp/providers/null_ls.lua
      null_ls = {
        -- Disable default list of sources provided by CosmicNvim
        default_cosmic_sources = false,
        -- Add additional sources here
        sources = {},
      },
    },
    -- See Cosmic defaults lsp/providers/tsserver.lua
    ts_utils = {},
  },
  -- See https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
  lsp_signature = {},
  -- See https://github.com/L3MON4D3/LuaSnip/blob/577045e9adf325e58f690f4d4b4a293f3dcec1b3/README.md#config
  luasnip = {},
  -- Default statusline icon
  statusline = {
    main_icon = '★',
  },
  -- See :h telescope.setup
  telescope = {},
  -- Theming, don't forget to run :CosmicReloadSync when changing themes
  -- Options: 'catppuccin', 'dracula', 'enfocado', 'github', 'gruvbox', 'kanagawa', 'nightfox', 'nord', 'onedark', 'rose-pine',
  theme = 'tokyonight', -- don't define or set to nil, if you want to enable your own theme in cosmic/config/plugins.lua
  -- See https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
  todo_comments = {},
  -- See :h nvim-treesitter-quickstart
  treesitter = {},
  -- See :h notify.setup
  notify = {},
  -- See :h cmp-usage
  nvim_cmp = {},
  -- See :h nvim-tree.setup
  nvim_tree = {},
  -- Add additional plugins
  add_plugins = {
    'ggandor/lightspeed.nvim',
    {
      'romgrk/barbar.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    },
  },
  -- Disable plugins enabled by CosmicNvim
  disable_builtin_plugins = {
    --[[
    'auto-session',
    'nvim-cmp',
    'colorizer',
    'dashboard',
    'fugitive',
    'gitsigns',
    'comment-nvim',
    'nvim-tree',
    'galaxyline',
    'telescope',
    'terminal',
    'theme',
    'todo-comments',
    'treesitter',
    ]]
  },
}

return config
