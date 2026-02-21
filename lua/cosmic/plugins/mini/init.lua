return {
  'nvim-mini/mini.nvim',
  version = false,
  init = function()
    require('mini.ai').setup()
  end,
}
