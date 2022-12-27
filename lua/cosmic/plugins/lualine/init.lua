local utils = require('cosmic.utils')
local icons = require('cosmic.theme.icons')

local custom_sections = {
  branch = { 'b:gitsigns_head', icon = icons.branch },
  diff = {
    'diff',
    source = utils.diff_source(),
    symbols = {
      added = icons.diff_add .. ' ',
      modified = icons.diff_modified .. ' ',
      removed = icons.diff_remove .. ' ',
    },
  },
  shortenedFilePath = {
    'filename',
    path = 0,
    symbols = {
      modified = icons.diff_modified,
    },
  },
  relativeFilePath = {
    'filename',
    path = 1,
    symbols = {
      modified = icons.diff_modified,
    },
  },
}

require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'filetype',
        icon_only = true,
        padding = {
          left = 1,
          right = 0,
        },
        separator = '',
      },
      custom_sections.shortenedFilePath,
    },
    lualine_c = { custom_sections.diff },
    lualine_x = { 'diagnostics' },
    lualine_y = { utils.get_lsp_status_str },
    lualine_z = { 'location', 'progress' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {
      {
        'filetype',
        icon_only = true,
        padding = {
          left = 1,
          right = 0,
        },
        separator = '',
      },
      custom_sections.shortenedFilePath,
    },
    lualine_c = { custom_sections.diff },
    lualine_x = { 'diagnostics' },
    lualine_y = { 'location', 'progress' },
    lualine_z = {},
  },
  winbar = {
    lualine_a = { utils.get_short_cwd },
    lualine_b = { custom_sections.branch },
    lualine_c = { custom_sections.relativeFilePath },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = { utils.get_short_cwd },
    lualine_b = { custom_sections.branch },
    lualine_c = { custom_sections.relativeFilePath },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'quickfix', 'fugitive', 'nvim-tree' },
})
