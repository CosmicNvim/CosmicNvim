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
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
}

local group = vim.api.nvim_create_augroup('CosmicNvimTreesitter', { clear = true })

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter')

    treesitter.setup({})
    treesitter.install(defaults.ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)

        if ok and defaults.indent.enable then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
      desc = 'Enable Tree-sitter features for supported buffers',
    })
  end,
}
