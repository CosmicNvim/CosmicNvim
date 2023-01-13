local user_config = require('cosmic.core.user')
local utils = require('cosmic.utils')
local lsp_utils = require('cosmic.utils.lsp')
local icons = require('cosmic.utils.icons')

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

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  config = function()
    require('lualine').setup(utils.merge({
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
        lualine_c = {
          custom_sections.diff,
        },
        lualine_x = { 'diagnostics' },
        lualine_y = { lsp_utils.get_lsp_status_str },
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
        lualine_x = {
          {
            'macro-recording',
            fmt = utils.show_macro_recording,
          },
          'filetype',
        },
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
    }, user_config.plugins.lualine or {}))

    vim.api.nvim_create_autocmd('RecordingEnter', {
      callback = function()
        require('lualine').refresh({
          place = { 'statusline' },
        })
      end,
    })

    vim.api.nvim_create_autocmd('RecordingLeave', {
      callback = function()
        -- This is going to seem really weird!
        -- Instead of just calling refresh we need to wait a moment because of the nature of
        -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
        -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
        -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
        -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
        local timer = vim.loop.new_timer()
        timer:start(
          50,
          0,
          vim.schedule_wrap(function()
            require('lualine').refresh({
              place = { 'statusline' },
            })
          end)
        )
      end,
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lualine'),
}
