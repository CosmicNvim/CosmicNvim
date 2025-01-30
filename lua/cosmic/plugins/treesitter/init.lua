local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local defaults = {
  ensure_installed = {
    'astro',
    'bash',
    'css',
    'go',
    'graphql',
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
    'styled',
    'tsx',
    'typescript',
    'vim',
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
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
}

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    { 'windwp/nvim-ts-autotag', lazy = true },
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
    { 'nvim-treesitter/nvim-treesitter-refactor', lazy = true },
  },
  event = 'BufReadPre',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup(u.merge(defaults, user_config.plugins.treesitter or {}))
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
      languages = {
        typescript = '// %s',
        python = '# %s',
      },
    })
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'treesitter'),
}
