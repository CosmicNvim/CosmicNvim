-- Add additional plugins as well as disable some core plugins

local plugins = {
  add = {
    {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function ()
        require('bufferline').setup {
          options = {
            numbers = "none",
            indicator_icon = '▎',
            buffer_close_icon = '',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
              -- remove extension from markdown files for example
              if buf.name:match('%.md') then
                return vim.fn.fnamemodify(buf.name, ':t:r')
              end
            end,
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            tab_size = 18,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              return "("..count..")"
            end,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = true,
            separator_style = "slant",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
          }
        }
      end
    },
  },
  disable = { -- disabling some core plugins may mean you'll have to remap some keybindings
  },
}

return plugins
