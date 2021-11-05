local config = require('cosmic.config')

local defaults = {
  ensure_installed = {
    'typescript',
    'javascript',
    'tsx',
    'html',
    'css',
    'lua',
    'json',
    'scss',
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
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
}

require('nvim-treesitter.configs').setup(vim.tbl_deep_extend('force', defaults, config.treesitter or {}))
