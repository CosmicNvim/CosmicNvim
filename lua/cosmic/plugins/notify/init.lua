local icons = require('cosmic.theme.icons')
local config = require('cosmic.config')

require('notify').setup(vim.tbl_deep_extend('force', {
  icons = {
    ERROR = icons.error,
    WARN = icons.warn,
    INFO = icons.info,
    DEBUG = icons.debug,
    TRACE = icons.trace,
  },
  background_colour = require('cosmic.theme.colors').notify_bg,
}, config.notify or {}))
vim.notify = require('notify')
