local T = require('tests.harness')

local function assert_cosmic_loaded()
  T.truthy(vim.fn.maparg(' kn', 'n') ~= '', 'core mapping <leader>kn')
  T.truthy(vim.fn.maparg(' fp', 'n') ~= '', 'Snacks mapping <leader>fp')
  T.truthy(require('lazy.core.config').plugins['conform.nvim'], 'conform plugin spec')
  T.truthy(vim.lsp.is_enabled('lua_ls'), 'lua_ls enabled')
end

return {
  {
    name = 'starts without errors',
    run = function()
      T.eq(vim.v.errmsg, '', 'v:errmsg')
      T.eq(T.capture_notifications(), {}, 'startup notifications')
      assert_cosmic_loaded()
    end,
  },
  {
    name = 'editor.lua leader and options reach plugin keymaps and specs',
    editor = function()
      vim.g.mapleader = ','
      vim.o.winborder = 'single'
    end,
    run = function()
      T.truthy(vim.fn.maparg(',fp', 'n') ~= '', 'Snacks mapping on the custom leader')
      T.eq(vim.fn.maparg(' fp', 'n'), '', 'Snacks mapping on the default leader')
      local config = require('lazy.core.config')
      T.eq(config.options.ui.border, 'single', 'lazy.nvim UI border')
      local toggleterm = require('lazy.core.plugin').values(config.plugins['toggleterm.nvim'], 'opts', false)
      T.eq(toggleterm.float_opts.border, 'single', 'toggleterm border')
    end,
  },
  {
    name = 'invalid config.lua falls back to defaults',
    config = { lsp = { format_timeout = '1000', servers = { rust_analyzer = true } } },
    run = function()
      local notes = T.capture_notifications()
      T.eq(#notes, 1, 'notification count')
      T.eq(notes[1].level, vim.log.levels.ERROR, 'notification level')
      T.truthy(notes[1].msg:find('`lsp.format_timeout` must be a positive number', 1, true), notes[1].msg)
      T.eq(require('cosmic.core.user').lsp.format_timeout, 3000, 'default format_timeout')
      T.eq(vim.lsp.is_enabled('rust_analyzer'), false, 'user servers ignored until fixed')
      assert_cosmic_loaded()
    end,
  },
  {
    name = 'config.lua that raises an error falls back to defaults',
    config = function()
      error('broken user config')
    end,
    run = function()
      local notes = T.capture_notifications()
      T.eq(#notes, 1, 'notification count')
      T.truthy(notes[1].msg:find('broken user config', 1, true), notes[1].msg)
      assert_cosmic_loaded()
    end,
  },
  {
    name = 'editor.lua that raises an error does not stop Cosmic',
    editor = function()
      error('broken editor config')
    end,
    run = function()
      local notes = T.capture_notifications()
      T.eq(#notes, 1, 'notification count')
      T.truthy(notes[1].msg:find('cosmic.config.editor', 1, true), notes[1].msg)
      T.truthy(notes[1].msg:find('broken editor config', 1, true), notes[1].msg)
      assert_cosmic_loaded()
    end,
  },
  {
    name = 'clipboard defaults to unnamedplus',
    run = function()
      vim.wait(100)
      T.eq(vim.o.clipboard, 'unnamedplus')
    end,
  },
  {
    name = 'clipboard set in editor.lua is kept',
    editor = function()
      vim.o.clipboard = ''
    end,
    run = function()
      vim.wait(100)
      T.eq(vim.o.clipboard, '')
    end,
  },
}
