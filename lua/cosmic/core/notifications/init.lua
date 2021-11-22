local icons = require('cosmic.core.theme.icons')
require('notify').setup({
  icons = {
    ERROR = icons.error,
    WARN = icons.warn,
    INFO = icons.info,
    DEBUG = icons.debug,
    TRACE = icons.trace,
  },
  background_colour = require('cosmic.core.theme.colors').notify_bg,
})
vim.notify = require('notify')
