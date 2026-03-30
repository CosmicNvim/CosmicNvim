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
local install_dir = vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'site')

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  dependencies = {
    { 'windwp/nvim-ts-autotag', lazy = true },
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
  },
  build = ':TSUpdate',
  config = function(plugin)
    local treesitter = require('nvim-treesitter')

    vim.opt.runtimepath:prepend(plugin.dir .. '/runtime')

    treesitter.setup({
      install_dir = install_dir,
    })
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

    require('nvim-ts-autotag').setup({})

    require('ts_context_commentstring').setup({
      enable_autocmd = false,
      languages = {
        python = '# %s',
        typescript = '// %s',
      },
    })
  end,
}
