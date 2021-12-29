local M = {}

M.supported_themes = {
  'catppuccin',
  'dracula',
  'enfocado',
  'github',
  'gruvbox',
  'kanagawa',
  'nightfox',
  'nord',
  'onedark',
  'rose-pine',
  'tokyonight',
}

function M.init(use, config)
  use({ -- color scheme
    'folke/tokyonight.nvim',
    as = 'tokyonight',
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_sidebars = { 'qf' }
      vim.cmd('color tokyonight')
    end,
    disable = config.theme ~= 'tokyonight',
  })

  use({
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      local catppuccin = require('catppuccin')
      catppuccin.setup({
        integrations = {
          gitsigns = true,
          telescope = true,
          dashboard = true,
          nvimtree = {
            enabled = true,
          },
        },
      })
      vim.cmd('colorscheme catppuccin')
    end,
    disable = config.theme ~= 'catppuccin',
  })

  use({
    'shaunsingh/nord.nvim',
    as = 'nord',
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      require('nord').set()
    end,
    disable = config.theme ~= 'nord',
  })

  use({
    'ellisonleao/gruvbox.nvim',
    as = 'gruvbox',
    requires = { 'rktjmp/lush.nvim' },
    config = function()
      vim.o.background = 'dark'
      vim.cmd('colorscheme gruvbox')
    end,
    disable = config.theme ~= 'gruvbox',
  })

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.g.rose_pine_variant = 'moon'
      vim.cmd('colorscheme rose-pine')
    end,
    disable = config.theme ~= 'rose-pine',
  })

  use({
    'EdenEast/nightfox.nvim',
    as = 'nightfox',
    config = function()
      vim.cmd('color nightfox')
    end,
    disable = config.theme ~= 'nightfox',
  })

  use({
    'navarasu/onedark.nvim',
    as = 'onedark',
    config = function()
      vim.cmd('color onedark')
    end,
    disable = config.theme ~= 'onedark',
  })

  use({
    'Mofiqul/dracula.nvim',
    as = 'dracula',
    config = function()
      vim.cmd('color dracula')
    end,
    disable = config.theme ~= 'dracula',
  })

  use({
    'wuelnerdotexe/vim-enfocado',
    as = 'enfocado',
    config = function()
      vim.g.enfocado_style = 'nature'
      vim.cmd('autocmd VimEnter * ++nested colorscheme enfocado')
    end,
    disable = config.theme ~= 'enfocado',
  })

  use({
    'rebelot/kanagawa.nvim',
    as = 'kanagawa',
    config = function()
      vim.cmd('colorscheme kanagawa')
    end,
    disable = config.theme ~= 'kanagawa',
  })

  use({
    'projekt0n/github-nvim-theme',
    as = 'github',
    config = function()
      require('github-theme').setup()
    end,
    disable = config.theme ~= 'github',
  })
end

return M
