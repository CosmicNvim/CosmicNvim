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
      python = { 'isort', 'black' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
    },
    -- Set default options
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 500,
    },
    formatters = {
      prettierd = {
        command = 'prettierd', -- Use system prettierd
        args = { '$FILENAME' }, -- Simplify args to just filename
        extra_filetypes = { 'astro' },
        --[[ env = { ]]
        --[[   PRETTIERD_LOCAL_PRETTIER_ONLY = 1, ]]
        --[[ }, ]]
      },
    },
  },
}
