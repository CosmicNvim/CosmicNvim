require('noice').setup({
  lsp = {
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
      auto_open = false, -- Automatically show signature help when typing a trigger character from the LSP
    },
  },
})
