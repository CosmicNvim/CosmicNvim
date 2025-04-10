local user_config = require('cosmic.core.user')
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    log_level = vim.log.levels.DEBUG,
    -- Define your formatters
    formatters_by_ft = {
      css = { 'prettierd' },
      go = { 'goimports', 'gofmt' },
      json = { 'prettierd' },
      lua = { 'stylua' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      python = {
        -- To fix auto-fixable lint errors.
        "ruff_fix",
        -- To run the Ruff formatter.
        "ruff_format",
        -- To organize the imports.
        "ruff_organize_imports",
      },
      --[[ javascript = { 'deno_fmt' }, ]]
      --[[ javascriptreact = { 'deno_fmt' }, ]]
      --[[ typescript = { 'deno_fmt' }, ]]
      --[[ typescriptreact = { 'deno_fmt' }, ]]
    },
    -- Set default options
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 1500,
    },
    formatters = {
      prettierd = {
        command = 'prettierd',  -- Use system prettierd
        args = { '$FILENAME' }, -- Simplify args to just filename
        extra_filetypes = { 'astro' },
        env = {
          PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
        },
      },
    },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'conform'),
}
