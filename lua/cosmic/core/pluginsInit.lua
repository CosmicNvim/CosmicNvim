---@diagnostic disable: missing-fields
local install_dir = require('cosmic.utils.cosmic').get_install_dir()

require('lazy').setup('cosmic.plugins', {
  lockfile = install_dir .. '/lazy-lock.json',
  defaults = { lazy = true },
  ui = {
    size = { width = 0.7, height = 0.7 },
    border = vim.o.winborder,
  },
  performance = {
    rtp = {
      -- Built-in runtime plugins Cosmic doesn't use. Names must match files in $VIMRUNTIME/plugin.
      disabled_plugins = {
        'gzip',
        'matchit',
        'netrwPlugin',
        'tarPlugin',
        'zipPlugin',
      },
    },
  },
})
