---@diagnostic disable: missing-fields
local user_config = require('cosmic.core.user')

return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {

    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      config = function()
        local ls = require('luasnip')
        local u = require('cosmic.utils')
        ls.config.set_config(u.merge({
          history = true,
          -- Update more often, :h events for more info.
          updateevents = 'TextChanged,TextChangedI',
          enable_autosnippets = true,
        }, user_config.plugins.luasnip or {}))

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

    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },

    sources = {
      default = { 'lsp', 'path', 'luasnip', 'buffer' },
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
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { 'sources.default' },

  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'blink.cmp'),
}
