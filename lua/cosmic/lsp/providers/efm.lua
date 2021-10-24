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
  css = {},
  html = {},
  lua = {},
  javascript = {},
  javascriptreact = {},
  json = {},
  markdown = {},
  scss = {},
  typescript = {},
  typescriptreact = {},
  yaml = {},
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
  stylua = { 'lua' }
}

local function is_formatter_disabled(formatter)
  if config.lsp and config.lsp.servers and config.lsp.servers.efm and config.lsp.servers.efm.disable_formatters then
    if vim.tbl_contains(config.lsp.servers.efm.disable_formatters, formatter) then
      return true
    end
  end
  return false
end

local languages = {}
for formatter, filetypes in pairs(formatters.defaults) do
  if not is_formatter_disabled(formatter) then
    for _, filetype in pairs(filetypes) do
      languages[filetype] = languages[filetype] or {}
      table.insert(languages[filetype], formatters[formatter])
    end
  end
end

-- print(vim.inspect(languages))
-- print(vim.inspect(languages['javascript']['prettier']))

return {
  init_options = { documentFormatting = true, codeAction = true },
  root_dir = function(fname)
    return util.root_pattern('.git')(fname)
      or util.root_pattern('tsconfig.base.json')(fname)
      or util.root_pattern('package.json')(fname)
      or util.root_pattern('.eslintrc.js')(fname)
      or util.root_pattern('tsconfig.json')(fname)
  end,
  filetypes = vim.tbl_keys(filetype_defaults),
  settings = { languages = languages },
}
