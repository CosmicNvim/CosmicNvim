return {
  { -- color scheme
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- use the night style
      style = 'night',
      light_style = 'moon',
      sidebars = { 'qf', 'packer', 'help' },
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    init = function()
      vim.cmd('color tokyonight')
    end,
  },
}
