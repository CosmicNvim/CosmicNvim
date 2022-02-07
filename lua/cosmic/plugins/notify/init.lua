local config = require('cosmic.core.user')
local icons = require('cosmic.theme.icons')
local u = require('cosmic.utils')

require('notify').setup(u.merge({
  icons = {
    ERROR = icons.error,
    WARN = icons.warn,
    INFO = icons.info,
    DEBUG = icons.debug,
    TRACE = icons.trace,
  },
  stages = 'slide',
  background_colour = require('cosmic.theme.colors').bg,
}, config.notify or {}))

vim.notify = require('notify')

require('cosmic.plugins.notify.highlights')
