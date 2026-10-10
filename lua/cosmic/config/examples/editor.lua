-- Copying this file preserves Cosmic defaults. Uncomment only the options you want to change.
-- This file loads before plugins, so the leader and options set here also apply to plugin keymaps.
-- Plugins are not available yet: require them inside mapping callbacks or autocmds, not at the top level.

local g = vim.g
local map = require('cosmic.utils').set_keymap
local opt = vim.opt

-- Default leader is <space>
-- g.mapleader = ','

-- Cosmic disables Neovim's Python, Node, Perl and Ruby providers. Re-enable one if a plugin needs it:
-- g.loaded_python3_provider = nil

-- Default indent is 2 spaces
-- opt.shiftwidth = 4
-- opt.softtabstop = 4
-- opt.tabstop = 4

-- Default floating-window border is 'rounded'. Plugins may set their own borders.
-- See :h 'winborder' for supported styles.
-- opt.winborder = 'single'

-- Browse keymaps with :lua Snacks.picker.keymaps()
-- or use :map and :map <leader>
-- Snacks uses <leader>fp for files, <leader>ff for Git files, and <leader>fs for grep.

-- Example: Additional insert mapping
-- map('i', 'jj', '<esc>', { desc = 'Exit insert mode' })

-- Mapping options:
-- map('n', ...)
-- map('v', ...)
-- map('i', ...)
-- map('t', ...)

-- Disable plugin keymaps through the plugin's keys spec in config.lua.
-- See the Snacks <leader>fp example there, rather than deleting lazy-managed keymaps here.

-- See :h vim.keymap for more info
