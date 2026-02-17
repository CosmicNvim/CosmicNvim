---@diagnostic disable: missing-fields
local install_dir = vim.env.COSMICNVIM_INSTALL_DIR or vim.fn.stdpath('config')

require('lazy').setup('cosmic.plugins', {
  lockfile = install_dir .. '/lazy-lock.json',
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
