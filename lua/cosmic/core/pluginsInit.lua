local u = require('cosmic.utils.cosmic')
local user_config = require('cosmic.core.user')
require('lazy').setup('cosmic.plugins', {
  lockfile = u.get_install_dir() .. '/lazy-lock.json', -- lockfile generated after running update.
  defaults = { lazy = true },
  ui = {
    border = user_config.border,
    size = { width = 0.7, height = 0.7 },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
