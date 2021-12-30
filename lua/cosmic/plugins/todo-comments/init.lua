local config = require('cosmic.config')
local icons = require('cosmic.theme.icons')
local utils = require('cosmic.utils')

require('todo-comments').setup(utils.merge({
  keywords = {
    FIX = {
      icon = icons.debug, -- icon used for the sign, and in search results
      color = 'error', -- can be a hex color, or a named color (see below)
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'fix', 'fixme', 'bug' }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = icons.check, color = 'info' },
    HACK = { icon = icons.flame, color = 'warning' },
    WARN = { icon = icons.warn, color = 'warning', alt = { 'WARNING', 'XXX' } },
    PERF = { icon = icons.perf, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
    NOTE = { icon = icons.note, color = 'hint', alt = { 'INFO' } },
  },
  colors = {
    error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
    warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
    info = { 'DiagnosticInfo', '#2563EB' },
    hint = { 'DiagnosticHint', '#10B981' },
    default = { 'Identifier', '#7C3AED' },
  },
}, config.todo_comments or {}))
