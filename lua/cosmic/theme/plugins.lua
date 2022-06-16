local M = {}

M.supported_themes = {
  'catppuccin',
  'dracula',
  'enfocado',
  'github',
  'gruvbox',
  'kanagawa',
  'monokai',
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
    commit = '8223c970677e4d88c9b6b6d81bda23daf11062bb',
    disable = config.theme ~= 'tokyonight',
  })

  use({
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      local catppuccin = require('catppuccin')
      catppuccin.setup({
        styles = {
          comments = 'italic',
          functions = 'NONE',
          keywords = 'NONE',
          strings = 'NONE',
          variables = 'NONE',
        },
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
    commit = 'b66d9a335e2562ca2c4758c12e384a9e7491ff29',
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
    commit = 'db98740c9429232508a25a98b7d41705f4d2fc1c',
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
    commit = '8135da3a90b257a2c902614e71d9cbbef8308cad',
    disable = config.theme ~= 'gruvbox',
  })

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.g.rose_pine_variant = 'moon'
      vim.cmd('colorscheme rose-pine')
    end,
    commit = '3f0a6c06da29c7b0f3fa49a313ae4d56f0dc58b8',
    disable = config.theme ~= 'rose-pine',
  })

  use({
    'EdenEast/nightfox.nvim',
    as = 'nightfox',
    config = function()
      vim.cmd('color nightfox')
    end,
    commit = 'b85c5c3a0e3b309ffa7d0a6ca33e430c91532ba0',
    disable = config.theme ~= 'nightfox',
  })

  use({
    'navarasu/onedark.nvim',
    as = 'onedark',
    config = function()
      vim.cmd('color onedark')
    end,
    commit = '52b1ebd80831dd1232b396b82a77fba977fb6e2c',
    disable = config.theme ~= 'onedark',
  })

  use({
    'Mofiqul/dracula.nvim',
    as = 'dracula',
    config = function()
      vim.cmd('color dracula')
    end,
    commit = 'a219971291c56bcca3827cb7bd40aaaef23feeca',
    disable = config.theme ~= 'dracula',
  })

  use({
    'wuelnerdotexe/vim-enfocado',
    as = 'enfocado',
    config = function()
      vim.g.enfocado_style = 'nature'
      vim.g.enfocado_plugins = {
        'cmp',
        'dashboard',
        'floaterm',
        'gitsigns',
        'lsp',
        'lsp-installer',
        'notify',
        'packer',
        'telescope',
        'todo-comments',
        'tree',
        'treesitter',
      }
      vim.cmd('autocmd VimEnter * ++nested colorscheme enfocado')
    end,
    commit = 'd7faf362f3573b1219c76b3a6ec22da4e568131e',
    disable = config.theme ~= 'enfocado',
  })

  use({
    'rebelot/kanagawa.nvim',
    as = 'kanagawa',
    config = function()
      vim.cmd('colorscheme kanagawa')
    end,
    commit = '76df2251e813fdec244b2b593be62accea930119',
    disable = config.theme ~= 'kanagawa',
  })

  use({
    'projekt0n/github-nvim-theme',
    as = 'github',
    config = function()
      require('github-theme').setup()
    end,
    commit = '1cc4a8d508bc6b846c72b9e629e8188ac24d0f13',
    disable = config.theme ~= 'github',
  })

  use({
    'tanvirtin/monokai.nvim',
    as = 'monokai',
    config = function()
      require('monokai').setup()
    end,
    disable = config.theme ~= 'monokai',
    commit = 'bff619d7a911cd8d8dcb5168db9ee6dfcc344934',
  })
end

return M
