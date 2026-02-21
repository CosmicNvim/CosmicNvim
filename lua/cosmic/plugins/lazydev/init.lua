return {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      'lazy.nvim',
      'toggleterm.nvim',
      'snacks.nvim',
    },
  },
  dependencies = { { 'Bilal2453/luvit-meta', lazy = true } },
}
