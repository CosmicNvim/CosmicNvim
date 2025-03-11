local user_config = require('cosmic.core.user')

return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {

    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      opts = {
        history = true,
        -- Update more often, :h events for more info.
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
      },
      init = function()
        -- extend html snippets to react files
        require('luasnip').filetype_extend('javascriptreact', { 'html' })
        require('luasnip').filetype_extend('typescriptreact', { 'html' })

        -- load snippets (friendly-snippets)
        require('luasnip.loaders.from_vscode').load()
      end,
      dependencies = {
        'rafamadriz/friendly-snippets',
      },
      enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'luasnip'),
    },
  },

  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    cmdline = {
      completion = {
        ghost_text = { enabled = true },
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ':'
          end,
        },
      },
    },
    completion = {
      accept = {
        -- Experimental auto-brackets support
        auto_brackets = {
          -- Whether to auto-insert brackets for functions
          enabled = true,
        },
      },
      menu = {
        border = 'rounded',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
        },
      },
      documentation = {
        auto_show_delay_ms = 0,
        auto_show = true,
        window = {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        },
      },
    },
    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = 'rounded',
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
      },
    },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'blink.cmp'),
}
