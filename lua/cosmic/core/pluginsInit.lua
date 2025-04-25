---@diagnostic disable: missing-fields
local u = require('cosmic.utils.cosmic')

require('lazy').setup('cosmic.plugins', {
  lockfile = u.get_install_dir() .. '/lazy-lock.json',
  defaults = { lazy = true },
  ui = {
    size = { width = 0.7, height = 0.7 },
    border = vim.opt.winborder:get(),
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'gzip',
        'zip',
        'zipPlugin',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'matchit',
      },
    },
  },
})
