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
    -- Enabled servers are installed through Mason automatically
    -- Enable non-default servers or override lspconfig/after/lsp server options
    servers = {
      -- Enable rust_analyzer with its lspconfig and after/lsp defaults
      rust_analyzer = true,

      -- Override vtsls defaults from lspconfig and after/lsp
      vtsls = {
        -- Disable only automatic formatting on save for this server
        format_on_save = false,
        -- Disable all formatting from this server, including manual formatting
        -- formatting = false,
        flags = {
          debounce_text_changes = 150,
        },
        on_attach = function(client, bufnr) end,
        settings = {},
      },

      -- Enable a custom/local server without asking Mason to install it
      -- my_custom_lsp = {
      --   mason = false,
      --   cmd = { 'my-custom-lsp' },
      --   filetypes = { 'foo' },
      -- },

      -- Disable a default server completely
      -- eslint = false,
    },
  },

  -- See :h vim.diagnostic.config for all diagnostic configuration options
  diagnostics = {},

  -- Plugin management (lazy.nvim)
  plugins = {
    -- Add an extra plugin
    'ggandor/lightspeed.nvim',

    -- Add a plugin with dependencies
    {
      'romgrk/barbar.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    -- Disable a built-in plugin
    -- {
    --   'nvim-lualine/lualine.nvim',
    --   enabled = false,
    -- },

    -- Override a built-in plugin
    -- {
    --   'nvim-treesitter/nvim-treesitter',
    --   opts = {
    --     ensure_installed = { 'lua', 'go', 'rust' },
    --   },
    -- },
  },
}

return config
