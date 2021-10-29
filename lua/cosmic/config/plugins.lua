-- Add additional plugins as well as disable some core plugins

--[[

local plugins = {
  add = {
    'ggandor/lightspeed.nvim',
    {
      'romgrk/barbar.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
    },
  },
  disable = { -- disabling some core plugins may mean you'll have to remap some keybindings
    'auto-session',
    'colorizer',
    'fugitive',
    'gitsigns',
    'kommentary',
    'statusline',
    'theme', -- if default theme is disabled, you will need to update add your own statusline
    'treesitter',
    'telescope',
    'terminal',
    'nvim-tree',
  },
}

return plugins

]]
