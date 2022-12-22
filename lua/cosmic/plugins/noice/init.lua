require('noice').setup({
  views = {
    notify = {
      merge = true,
    },
    hover = {
      border = {
        style = 'rounded',
      },
      position = { row = 2, col = 2 },
    },
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
})

require('cosmic.plugins.noice.mappings')
