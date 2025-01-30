-- Override Cosmic configuration options

local config = {
  -- See :h nvim_open_win for possible border options
  border = 'rounded',
  -- LSP settings
  lsp = {
    -- Enable/disable inlay hints
    inlay_hint = false,
    -- Time in MS before format timeout
    format_timeout = 1000,
    -- Set to false to disable rename notification
    rename_notification = true,
    -- Enable non-default servers, use default lsp config
    -- Check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers

    -- lsp servers that should be installed
    ensure_installed = {
      'rust_analyzer',
    },

    -- lsp servers that should be enabled
    servers = {
      -- Enable rust_analyzer
      rust_analyzer = true,

      -- Enable vtsls w/custom settings
      vtsls = {
        -- Disable formatting (defaults to true)
        format_on_save = false,
        -- OR add/override server options
        opts = {
          on_attach = function(client, bufnr) end,
          flags = {
            debounce_text_changes = 150,
          },
          settings = {},
        },
      },
    },
  },

  -- See :h vim.diagnostic.config for all diagnostic configuration options
  -- See ./lua/cosmic/lsp/diagnostics.lua for default options
  diagnostics = {},

  -- adjust default plugin settings, see full list of default plugins at ./lua/cosmic/plugins
  plugins = {
    -- See https://github.com/rmagatti/auto-session#%EF%B8%8F-configuration
    auto_session = {},
    -- See https://github.com/CosmicNvim/cosmic-ui#%EF%B8%8F-configuration
    cosmic_ui = {},
    -- See :h gitsigns-usage
    gitsigns = {},
    -- See https://github.com/nvim-lualine/lualine.nvim#default-configuration
    lualine = {},
    -- See https://github.com/L3MON4D3/LuaSnip/blob/577045e9adf325e58f690f4d4b4a293f3dcec1b3/README.md#config
    luasnip = {},
    -- See https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
    todo_comments = {},
    -- See :h nvim-treesitter-quickstart
    treesitter = {},
  },

  -- Disable plugins default enabled by CosmicNvim
  disable_builtin_plugins = {
    --[[
    'auto-session',
    'colorizer',
    'fugitive',
    'gitsigns',
    'lualine',
    'noice',
    'todo-comments',
    'treesitter',
    ]]
  },

  -- Add additional plugins (lazy.nvim)
  add_plugins = {
    'ggandor/lightspeed.nvim',
    {
      'romgrk/barbar.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
  },
}

return config
