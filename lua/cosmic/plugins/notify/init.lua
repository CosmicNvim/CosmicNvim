local config = require('cosmic.config')
local icons = require('cosmic.theme.icons')
local utils = require('cosmic.utils')

require('notify').setup(utils.merge({
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
