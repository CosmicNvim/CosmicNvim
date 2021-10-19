local util = require('lspconfig').util

local stylua = {
  formatCommand = 'stylua -s --quote-style AutoPreferSingle --indent-type Spaces --indent-width 2 -',
  formatStdin = true,
}

local prettier = {
  --  formatCommand = 'prettier --stdin-filepath ${INPUT}',
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
}

local filetypes = {
  css = { prettier },
  html = { prettier },
  lua = { stylua },
  javascript = { prettier },
  javascriptreact = { prettier },
  json = { prettier },
  markdown = { prettier },
  scss = { prettier },
  typescript = { prettier },
  typescriptreact = { prettier },
  yaml = { prettier },
}

return {
  init_options = { documentFormatting = true, codeAction = true },
  root_dir = function(fname)
    return util.root_pattern('.git')(fname)
      or util.root_pattern('tsconfig.base.json')(fname)
      or util.root_pattern('package.json')(fname)
      or util.root_pattern('.eslintrc.js')(fname)
      or util.root_pattern('tsconfig.json')(fname)
  end,
  filetypes = vim.tbl_keys(filetypes),
  settings = { languages = filetypes },
}
