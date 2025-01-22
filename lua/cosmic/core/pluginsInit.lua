---@diagnostic disable: missing-fields, duplicate-set-field
local u = require('cosmic.utils.cosmic')
local user_config = require('cosmic.core.user')

require('lazy').setup('cosmic.plugins', {
  lockfile = u.get_install_dir() .. '/lazy-lock.json',
  defaults = { lazy = true },
  ui = {
    border = user_config.border,
    size = { width = 0.7, height = 0.7 },
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

-- ignore banned messages
local banned_messages = { 'No information available' }
vim.notify = function(msg, ...)
  for _, banned in ipairs(banned_messages) do
    if msg == banned then
      return
    end
  end
  return require('notify')(msg, ...)
end
