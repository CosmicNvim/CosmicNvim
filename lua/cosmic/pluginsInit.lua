local present, cosmic_packer = pcall(require, 'cosmic.packer')

if not present then
  return false
end

local packer = cosmic_packer.packer
local use = packer.use

local ok, user_plugins = pcall(require, 'cosmic.config.plugins')
if not ok then
  user_plugins = {
    add = {},
    disable = {},
  }
end

if not vim.tbl_islist(user_plugins.add) then
  user_plugins.add = {}
end
if not vim.tbl_islist(user_plugins.disable) then
  user_plugins.disable = {}
end

local config = require('cosmic.config')

return packer.startup(function()
  use({
    'wbthomason/packer.nvim',
    'lewis6991/impatient.nvim',
    'nathom/filetype.nvim',
    'nvim-lua/plenary.nvim',
  })

  use({ -- color scheme
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_sidebars = { 'qf' }
      vim.cmd('color tokyonight')
    end,
    disable = config.theme ~= 'tokyonight.nvim',
  })

  use({
    'Pocco81/Catppuccino.nvim',
    config = function()
      vim.cmd('color catppuccin')
    end,
    branch = 'dev-remaster',
    disable = config.theme ~= 'Catppuccino.nvim',
  })

  use({
    'shaunsingh/nord.nvim',
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      require('nord').set()
    end,
    disable = config.theme ~= 'nord.nvim',
  })

  use({
    'rcarriga/nvim-notify',
    config = function()
      local icons = require('cosmic.core.theme.icons')
      require('notify').setup({
        icons = {
          ERROR = icons.error,
          WARN = icons.warn,
          INFO = icons.info,
          DEBUG = icons.debug,
          TRACE = icons.trace,
        },
      })
      vim.notify = require('notify')
    end,
    after = config.theme,
    disable = vim.tbl_contains(user_plugins.disable, 'notify'),
  })

  -- theme stuff
  use({ -- statusline
    'NTBBloodbath/galaxyline.nvim',
    branch = 'main',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('cosmic.core.statusline')
    end,
    after = config.theme,
    disable = vim.tbl_contains(user_plugins.disable, 'statusline'),
  })

  -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('cosmic.core.file-explorer')
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

  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('cosmic.lsp')
    end,
    requires = {
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          -- must happen after servers are set up
          require('lsp_signature').setup({
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
              border = 'rounded',
            },
          })
        end,
        after = 'nvim-lspconfig',
      },
      { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
      { 'williamboman/nvim-lsp-installer' },
    },
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('cosmic.lsp.providers.null_ls')
    end,
    requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    disable = vim.tbl_contains(user_plugins.disable, 'null-ls'),
  })

  use({
    'onsails/lspkind-nvim',
    event = 'InsertEnter',
    disable = vim.tbl_contains(user_plugins.disable, 'autocomplete'),
  })

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('cosmic.lsp.autocomplete').init()
    end,
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer', after = 'cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua', after = 'cmp-buffer' },
      { 'hrsh7th/cmp-path', after = 'cmp-nvim-lua' },
      {
        'windwp/nvim-autopairs',
        config = function()
          require('cosmic.lsp.autocomplete').autopairs()
        end,
        after = 'cmp-path',
      },
    },
    after = 'lspkind-nvim',
    disable = vim.tbl_contains(user_plugins.disable, 'autocomplete'),
  })

  use({
    'L3MON4D3/LuaSnip',
    config = function()
      require('cosmic.core.snippets')
    end,
    requires = {
      'rafamadriz/friendly-snippets',
    },
    disable = vim.tbl_contains(user_plugins.disable, 'autocomplete'),
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
    opt = true,
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
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_plugins.disable, 'telescope'),
  })

  -- session/project management
  use({
    'glepnir/dashboard-nvim',
    config = function()
      require('cosmic.core.dashboard')
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'dashboard'),
  })

  use({
    'rmagatti/auto-session',
    event = 'VimEnter',
    config = function()
      require('cosmic.core.session')
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
    event = 'BufEnter',
    config = function()
      require('cosmic.core.treesitter')
    end,
    disable = vim.tbl_contains(user_plugins.disable, 'treesitter'),
  })

  -- comments and stuff
  use({
    'b3nj5m1n/kommentary',
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_plugins.disable, 'kommentary'),
  })

  -- todo highlights
  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local icons = require('cosmic.core.theme.icons')
      require('todo-comments').setup({
        keywords = {
          FIX = {
            icon = icons.debug, -- icon used for the sign, and in search results
            color = 'error', -- can be a hex color, or a named color (see below)
            alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'fix', 'fixme', 'bug' }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = icons.check, color = 'info' },
          HACK = { icon = icons.flame, color = 'warning' },
          WARN = { icon = icons.warn, color = 'warning', alt = { 'WARNING', 'XXX' } },
          PERF = { icon = icons.perf, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = icons.note, color = 'hint', alt = { 'INFO' } },
        },
        colors = {
          error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
          warning = { 'DiagnosticWarning', 'WarningMsg', '#FBBF24' },
          info = { 'DiagnosticInformation', '#2563EB' },
          hint = { 'DiagnosticHint', '#10B981' },
          default = { 'Identifier', '#7C3AED' },
        },
      })
    end,
    event = 'BufWinEnter',
    disable = vim.tbl_contains(user_plugins.disable, 'todo-comments'),
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

  if user_plugins.add and not vim.tbl_isempty(user_plugins.add) then
    for _, plugin in pairs(user_plugins.add) do
      use(plugin)
    end
  end

  if cosmic_packer.first_install then
    packer.sync()
  end
end)
