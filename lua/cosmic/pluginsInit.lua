local present, cosmic_packer = pcall(require, 'cosmic.packer')

if not present then
  return false
end

local packer = cosmic_packer.packer
local use = packer.use

local ok, user_plugins = pcall(require, 'cosmic.config.plugins')
if not ok then
  error(string.format('Error loading user custom plugins...\n\n%s', user_plugins))
  return false
end

if user_plugins == true then
  user_plugins = {
    disable = {},
  }
end

if not vim.tbl_islist(user_plugins.disable) then
  user_plugins.disable = {}
end

return packer.startup(function()
  use('wbthomason/packer.nvim')

  use({
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
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
    disable = vim.tbl_contains(user_plugins.disable, 'nvim-tree'),
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
      'hrsh7th/cmp-nvim-lua',
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
    disable = vim.tbl_contains(user_plugins.disable, 'fugitive'),
  })

  -- git column signs
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    event = 'BufRead',
    config = function()
      require('gitsigns').setup()
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'gitsigns'),
  })

  -- floating terminal
  use({
    'voldikss/vim-floaterm',
    opt = true,
    cmd = { 'FloatermToggle', 'FloatermNew', 'FloatermSend' },
    config = function()
      require('cosmic.core.terminal')
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'terminal'),
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
      require('cosmic.core.navigation')
    end,
    event = 'BufRead',
    disable = vim.tbl_contains(user_plugins.disable, 'telescope'),
  })

  -- session management
  use({
    'rmagatti/auto-session',
    event = 'VimEnter',
    config = function()
      require('auto-session').setup({
        pre_save_cmds = { 'NvimTreeClose', 'cclose' },
      })
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'auto-session'),
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
    disable = vim.tbl_contains(user_plugins.disable, 'treesitter'),
  })

  -- comments and stuff
  use({
    'b3nj5m1n/kommentary',
    event = 'BufRead',
    disable = vim.tbl_contains(user_plugins.disable, 'kommentary'),
  })

  -- colorized hex codes
  use({
    'norcalli/nvim-colorizer.lua',
    opt = true,
    cmd = { 'ColorizerToggle' },
    config = function()
      require('colorizer').setup()
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'colorizer'),
  })

  if user_plugins.add and not vim.tbl_isempty(user_plugins) then
    for _, plugin in pairs(user_plugins.add) do
      use(plugin)
    end
  end

  if cosmic_packer.first_install then
    packer.sync()
  end
end)
