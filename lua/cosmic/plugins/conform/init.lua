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
      html = { 'prettierd' },
      javascript = { 'eslint_d', 'prettierd' },
      javascriptreact = { 'eslint_d', 'prettierd' },
      json = { 'prettierd' },
      lua = { 'stylua' },
      --[[ markdown = { 'prettierd' }, ]]
      scss = { 'prettierd' },
      typescript = { 'eslint_d', 'prettierd' },
      typescriptreact = { 'eslint_d', 'prettierd' },
      python = {
        -- To fix auto-fixable lint errors.
        'ruff_fix',
        -- To run the Ruff formatter.
        'ruff_format',
        -- To organize the imports.
        'ruff_organize_imports',
      },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },

    -- @TODO: make this simpler
    format_on_save = function(bufnr)
      if not vim.g.format_on_save_enabled then
        return
      end

      local ok, cosmic = pcall(require, 'cosmic-ui')
      if not (ok and cosmic.is_setup and cosmic.is_setup()) then
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end

      local st = cosmic.formatters.status({ scope = 'buffer', bufnr = bufnr })
      local enabled = {}
      for _, f in ipairs((st and st.conform and st.conform.formatters) or {}) do
        if f.enabled then
          enabled[#enabled + 1] = f.name
        end
      end

      if #enabled == 0 then
        return nil
      end

      return {
        timeout_ms = 500,
        formatters = enabled,
        lsp_format = 'fallback',
      }
    end,
    formatters = {
      prettierd = {
        command = 'prettierd', -- Use system prettierd
        args = { '$FILENAME' }, -- Simplify args to just filename
        extra_filetypes = { 'astro' },
        env = {
          PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
        },
      },
    },
  },
}
