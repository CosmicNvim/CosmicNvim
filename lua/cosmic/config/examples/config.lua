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

  -- Plugin management (lazy.nvim)
  plugins = {
    -- Add additional plugins
    add = {
      'ggandor/lightspeed.nvim',
      {
        'romgrk/barbar.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
      },
    },

    -- Disable built-in plugins by repo path
    disable = {
      -- 'nvim-lualine/lualine.nvim',
      -- 'nvim-treesitter/nvim-treesitter',
    },

    -- Override opts for built-ins or any plugin using lazy.nvim opts
    opts = {
      -- ['nvim-lualine/lualine.nvim'] = {
      --   options = { theme = 'catppuccin' },
      -- },
    },

    -- Full lazy.nvim spec overrides (for advanced cases)
    override = {
      -- ['nvim-treesitter/nvim-treesitter'] = {
      --   opts = {
      --     ensure_installed = { 'lua', 'go', 'rust' },
      --   },
      -- },
    },
  },
}

return config
