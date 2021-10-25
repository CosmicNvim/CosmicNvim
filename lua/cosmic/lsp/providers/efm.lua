local util = require('lspconfig').util
local config = require('cosmic.config')
local formatters = {}

formatters.stylua = {
  formatCommand = 'stylua -s --quote-style AutoPreferSingle --indent-type Spaces --indent-width 2 -',
  formatStdin = true,
}

formatters.eslint = {
  lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
  lintIgnoreExitCode = true,
  formatCommand = 'eslint_d --stdin --fix-to-stdout --stdin-filename=${INPUT}',
  formatStdin = true,
}

formatters.prettier = {
  --  formatCommand = 'prettier --stdin-filepath ${INPUT}',
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
}

local filetype_defaults = {
  'css',
  'html',
  'lua',
  'javascript',
  'javascriptreact',
  'json',
  'markdown',
  'scss',
  'typescript',
  'typescriptreact',
  'yaml',
}

formatters.defaults = {
  eslint = {
    'javascript',
    'javascriptreact',
    'json',
    'typescriptreact',
    'typescript',
  },
  prettier = {
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'typescriptreact',
    'typescript',
    'markdown',
    'scss',
    'yaml',
  },
  stylua = { 'lua' },
}

local languages = {}
for formatter, filetypes in pairs(formatters.defaults) do
  -- disable specific formatters
  if not vim.tbl_contains(config.lsp.servers.efm.disable_formatters, formatter) then
    for _, filetype in pairs(filetypes) do
      languages[filetype] = languages[filetype] or {}
      table.insert(languages[filetype], formatters[formatter])
    end
  end
end

return {
  init_options = { documentFormatting = true, codeAction = true },
  root_dir = function(fname)
    return util.root_pattern('.git')(fname)
      or util.root_pattern('tsconfig.base.json')(fname)
      or util.root_pattern('package.json')(fname)
      or util.root_pattern('.eslintrc.js')(fname)
      or util.root_pattern('tsconfig.json')(fname)
  end,
  filetypes = filetype_defaults,
  settings = { languages = languages },
}
