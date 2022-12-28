local user_config = require('cosmic.core.user')

require('lazy').setup({

  -- initialize theme plugins
  { -- color scheme
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      -- set up theme
      require('cosmic.plugins.tokyonight')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'tokyonight'),
  },

  {
    'folke/noice.nvim',
    config = function()
      require('cosmic.plugins.noice')
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- theme stuff
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('cosmic.plugins.lualine')
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lualine'),
  },

  -- file explorer
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('cosmic.plugins.nvim-tree')
    end,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-tree'),
  },

  {
    'CosmicNvim/cosmic-ui',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('cosmic.plugins.cosmic-ui')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'cosmic-ui'),
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('cosmic.lsp.providers.null_ls')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'null-ls'),
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require('cosmic.lsp')
    end,
    dependencies = {
      { 'b0o/SchemaStore.nvim' },
      { 'williamboman/nvim-lsp-installer' },
      { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
    },
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-lspconfig'),
  },

  -- autocompletion
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require('cosmic.plugins.nvim-cmp')
    end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
    },
    event = 'InsertEnter',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-cmp'),
  },

  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('cosmic.plugins.luasnip')
    end,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'luasnip'),
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('cosmic.plugins.auto-pairs')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'autopairs'),
  },

  -- git commands
  {
    'tpope/vim-fugitive',
    opt = true,
    cmd = 'Git',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'fugitive'),
  },

  -- git column signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opt = true,
    event = 'BufWinEnter',
    config = function()
      require('cosmic.plugins.gitsigns')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'gitsigns'),
  },

  -- floating terminal
  {
    'voldikss/vim-floaterm',
    opt = true,
    event = 'BufWinEnter',
    config = function()
      require('cosmic.plugins.terminal')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'terminal'),
  },

  -- file navigation
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      require('cosmic.plugins.telescope.mappings').init()
      require('cosmic.plugins.telescope')
    end,
    event = 'BufWinEnter',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'telescope'),
  },

  -- session/project management
  {
    'glepnir/dashboard-nvim',
    config = function()
      require('cosmic.plugins.dashboard')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'dashboard'),
  },

  {
    'rmagatti/auto-session',
    config = function()
      require('cosmic.plugins.auto-session')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'auto-session'),
  },

  -- lang/syntax stuff
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    build = ':TSUpdate',
    config = function()
      require('cosmic.plugins.treesitter')
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'treesitter'),
  },

  -- comments and stuff
  {
    'numToStr/Comment.nvim',
    config = function()
      require('cosmic.plugins.comments')
    end,
    event = 'BufWinEnter',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'comment-nvim'),
  },

  -- todo highlights
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('cosmic.plugins.todo-comments')
    end,
    event = 'BufWinEnter',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'todo-comments'),
  },
  -- colorized hex codes
  {
    'norcalli/nvim-colorizer.lua',
    opt = true,
    cmd = { 'ColorizerToggle' },
    config = function()
      require('colorizer').setup()
    end,
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'colorizer'),
  },
}, {
  ui = {
    border = 'rounded',
  },
})

--[[ return packer.startup(function() ]]
--[[]]
--[[   if user_config.add_plugins and not vim.tbl_isempty(user_config.add_plugins) then ]]
--[[     for _, plugin in pairs(user_config.add_plugins) do ]]
--[[       use(plugin) ]]
--[[     end ]]
--[[   end ]]
--[[]]
--[[   if cosmic_packer.first_install then ]]
--[[     packer.sync() ]]
--[[   end ]]
--[[ end) ]]
