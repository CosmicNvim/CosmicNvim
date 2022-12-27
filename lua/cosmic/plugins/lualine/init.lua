local utils = require('cosmic.utils')

local custom_sections = {
  diff = {
    'diff',
    source = utils.diff_source(),
  },
  shortenedFilePath = {
    'filename',
    path = 0,
  },
  relativeFilePath = {
    'filename',
    path = 1,
  },
}

require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { custom_sections.shortenedFilePath },
    lualine_c = { custom_sections.diff },
    lualine_x = { 'diagnostics' },
    lualine_y = { utils.get_lsp_status_str },
    lualine_z = { 'location', 'progress' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { custom_sections.shortenedFilePath },
    lualine_c = { custom_sections.diff },
    lualine_x = { 'diagnostics' },
    lualine_y = { 'location', 'progress' },
    lualine_z = {},
  },
  winbar = {
    lualine_a = { utils.get_short_cwd },
    lualine_b = { 'branch' },
    lualine_c = { custom_sections.relativeFilePath },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = { utils.get_short_cwd },
    lualine_b = { 'branch' },
    lualine_c = { custom_sections.relativeFilePath },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {},
  },
})
