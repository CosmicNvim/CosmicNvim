-- Copying this file preserves Cosmic defaults. Uncomment only the options you want to change.

local config = {
  -- LSP settings
  lsp = {
    -- Enable inlay hints (default: false)
    -- inlay_hint = true,
    -- Format timeout in milliseconds (default: 3000)
    -- format_timeout = 5000,
    -- Enabled servers are installed through Mason automatically
    -- Enable non-default servers or override lspconfig/after/lsp server options
    servers = {
      -- Enable rust_analyzer with its lspconfig and after/lsp defaults
      -- rust_analyzer = true,

      -- Override tsc defaults from lspconfig and after/lsp
      -- tsc = {
      --   -- Disable only automatic LSP formatting on save for this server
      --   format_on_save = false,
      --   -- Disable all LSP formatting from this server, including manual formatting
      --   formatting = false,
      --   flags = {
      --     debounce_text_changes = 150,
      --   },
      -- },

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
    -- 'ggandor/lightspeed.nvim',

    -- Add a plugin with dependencies
    -- {
    --   'romgrk/barbar.nvim',
    --   dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- },

    -- Disable a built-in plugin
    -- {
    --   'nvim-lualine/lualine.nvim',
    --   enabled = false,
    -- },

    -- Disable the Snacks Find Files mapping using lazy.nvim's keys override
    -- {
    --   'folke/snacks.nvim',
    --   keys = {
    --     { '<leader>fp', false },
    --   },
    -- },

    -- Override a built-in plugin. lazy.nvim replaces lists in `opts` tables,
    -- so extend list options such as Tree-sitter parsers in an `opts` function.
    -- {
    --   'nvim-treesitter/nvim-treesitter',
    --   opts = function(_, opts)
    --     vim.list_extend(opts.ensure_installed, { 'rust' })
    --   end,
    -- },
  },
}

return config
