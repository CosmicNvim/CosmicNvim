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
    -- Enable non-default servers, use default lsp config
    -- Check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers

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

  -- Disable plugins default enabled by CosmicNvim
  -- See ./lua/cosmic/plugins for list of default plugins
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
