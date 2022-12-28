local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'folke/noice.nvim',
  config = function()
    require('noice').setup(u.merge({
      views = {
        notify = {
          merge = true,
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        hover = {
          enabled = false,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
    }, user_config.plugins.noice or {}))

    require('cosmic.plugins.noice.mappings')
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
