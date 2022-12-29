local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'folke/noice.nvim',
  config = function()
    require('noice').setup(u.merge({
      presets = {
        lsp_doc_border = true,
      },
      views = {
        notify = {
          merge = true,
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          -- @TODO: why doesn't this work?
          ['cmp.entry.get_documentation'] = false,
        },
      },
    }, user_config.plugins.noice or {}))

    require('cosmic.plugins.noice.mappings')
  end,
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
