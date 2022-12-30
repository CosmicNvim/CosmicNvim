local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  ensure_installed = {
    'astro',
    'css',
    'go',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'php',
    'python',
    'regex',
    'scss',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
}

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'windwp/nvim-ts-autotag',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'nvim-treesitter/nvim-treesitter-refactor',
  },
  event = 'BufEnter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup(u.merge(defaults, user_config.plugins.treesitter or {}))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'treesitter'),
}
