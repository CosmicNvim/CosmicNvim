local function get_opts()
  local utils = require('cosmic.utils')
  local icons = require('cosmic.utils.icons')

  local custom_sections = {
    branch = { 'b:gitsigns_head', icon = icons.branch },
    diff = {
      'diff',
      symbols = {
        added = icons.diff_add .. ' ',
        modified = icons.diff_modified .. ' ',
        removed = icons.diff_remove .. ' ',
      },
    },
    shortened_file_path = {
      'filename',
      path = 0,
      symbols = {
        modified = icons.diff_modified,
      },
    },
    relative_file_path = {
      'filename',
      path = 1,
      symbols = {
        modified = icons.diff_modified,
      },
    },
  }

  return {
    options = {
      theme = 'tokyonight',
    },
    sections = {
      lualine_a = {
        'mode',
      },
      lualine_b = {
        custom_sections.diff,
        'diagnostics',
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        'lsp_status',
        'filetype',
      },
      lualine_z = {
        {
          'location',
          padding = 0,
        },
        'progress',
      },
    },
    inactive_sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        custom_sections.diff,
        'diagnostics',
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        'lsp_status',
        'filetype',
      },
      lualine_z = { 'location', 'progress' },
    },
    winbar = {
      lualine_a = {
        utils.get_short_cwd,
      },
      lualine_b = {
        custom_sections.relative_file_path,
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          'macro-recording',
          fmt = utils.show_macro_recording,
        },
      },
      lualine_z = {
        custom_sections.branch,
      },
    },
    inactive_winbar = {
      lualine_a = { utils.get_short_cwd },
      lualine_b = {},
      lualine_c = { custom_sections.relative_file_path },
      lualine_x = { 'filetype' },
      lualine_y = {},
      lualine_z = {
        custom_sections.branch,
      },
    },
    extensions = { 'quickfix', 'fugitive', 'oil', 'mason', 'toggleterm', 'lazy', 'oil' },
  }
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = get_opts,
  config = function(_, opts)
    require('lualine').setup(opts)

    local lualine_augroup = vim.api.nvim_create_augroup('CosmicNvimLualine', { clear = true })
    vim.api.nvim_create_autocmd('RecordingEnter', {
      group = lualine_augroup,
      callback = function()
        require('lualine').refresh({
          place = { 'winbar' },
        })
      end,
    })

    vim.api.nvim_create_autocmd('RecordingLeave', {
      group = lualine_augroup,
      callback = function()
        -- Wait until reg_recording() clears before refreshing the winbar.
        vim.defer_fn(function()
          require('lualine').refresh({
            place = { 'winbar' },
          })
        end, 50)
      end,
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
}
