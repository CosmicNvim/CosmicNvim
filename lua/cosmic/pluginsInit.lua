local present, packer = pcall(require, "cosmic.packer")

if not present then
   return false
end

local use = packer.use

return packer.startup(function()
  use('wbthomason/packer.nvim')

  use({
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end
  })

  use({ -- color scheme
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_sidebars = { 'qf', 'packer' }
      vim.cmd('color tokyonight')
    end,
  })

  use({ -- icons
    'kyazdani42/nvim-web-devicons',
    after = 'tokyonight.nvim',
  })

  -- theme stuff
  use({ -- statusline
    'NTBBloodbath/galaxyline.nvim',
    branch = 'main',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('cosmic.core.statusline')
    end,
    after = 'nvim-web-devicons',
  })

  -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('cosmic.core.file-explorer').init()
    end,
    opt = true,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
  })

  use({ -- lsp
    'williamboman/nvim-lsp-installer',
    requires = {
      'neovim/nvim-lspconfig',
      'ray-x/lsp_signature.nvim',
      'jose-elias-alvarez/nvim-lsp-ts-utils',
    },
    config = function()
      require('cosmic.lsp')
    end,
  })

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('cosmic.lsp.autocomplete')
    end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'windwp/nvim-autopairs',
      'onsails/lspkind-nvim',
    },
  })

  -- git commands
  use({
    'tpope/vim-fugitive',
    opt = true,
    cmd = 'Git',
  })

  -- git column signs
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    event = 'BufRead',
    config = function()
      require('gitsigns').setup()
    end,
  })

  -- floating terminal
  use({
    'voldikss/vim-floaterm',
    opt = true,
    cmd = { 'FloatermToggle', 'FloatermNew', 'FloatermSend' },
    config = function()
      require('cosmic.core.terminal')
    end,
  })

  -- file navigation
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
    },
    config = function()
      require('cosmic.core.file-navigation')
    end,
    event = 'BufRead',
  })

  -- session management
  use({
    'rmagatti/auto-session',
    event = 'VimEnter',
    config = function()
      require('auto-session').setup({
        pre_save_cmds = { 'NvimTreeClose', 'TroubleClose', 'cclose' },
      })
    end,
  })

  -- lang/syntax stuff
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    run = ':TSUpdate',
    config = function()
      require('cosmic.core.treesitter')
    end,
  })

  -- comments and stuff
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
    event = 'BufRead',
  })

  -- colorized hex codes
  use({
    'norcalli/nvim-colorizer.lua',
    opt = true,
    cmd = { 'ColorizerToggle' },
    config = function()
      require('colorizer').setup()
    end,
  })
end)
