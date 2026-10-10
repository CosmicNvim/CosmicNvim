local T = require('tests.harness')

local formatting_server = { lsp = { servers = { cosmic_fake = T.fake_server_config({ formatting = true }) } } }

--- Replace the buffer contents and save.
---@param lines string[]
local function save(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.cmd('silent write')
end

return {
  {
    name = 'formats on save through LSP when no conform formatter applies',
    config = formatting_server,
    run = function()
      local path = T.tmpdir() .. '/a.cosmictest'
      T.open_with_fake_server(path)
      save({ 'raw' })
      T.eq(vim.fn.readfile(path), { 'formatted' }, 'first save')
      T.truthy(package.loaded['cosmic-ui'], 'cosmic-ui loaded by the first save')
      save({ 'raw again' })
      T.eq(vim.fn.readfile(path), { 'formatted' }, 'later save')
    end,
  },
  {
    name = 'turning off LSP formatting in cosmic-ui stops the fallback',
    config = formatting_server,
    run = function()
      local path = T.tmpdir() .. '/a.cosmictest'
      T.open_with_fake_server(path)
      save({ 'raw' })
      require('cosmic-ui').formatters.disable({ scope = 'buffer', backend = 'lsp' })
      save({ 'raw again' })
      T.eq(vim.fn.readfile(path), { 'raw again' })
    end,
  },
  {
    name = 'format_on_save = false keeps a server from formatting on save',
    config = {
      lsp = { servers = { cosmic_fake = T.fake_server_config({ formatting = true }, { format_on_save = false }) } },
    },
    run = function()
      local path = T.tmpdir() .. '/a.cosmictest'
      T.open_with_fake_server(path)
      save({ 'raw' })
      T.eq(vim.fn.readfile(path), { 'raw' })
    end,
  },
  {
    name = 'lsp.format_timeout is used for format on save',
    config = vim.tbl_deep_extend('force', formatting_server, { lsp = { format_timeout = 1234 } }),
    run = function()
      local bufnr = T.open_with_fake_server(T.tmpdir() .. '/a.cosmictest')
      local spec = require('lazy.core.config').plugins['conform.nvim']
      local opts = require('lazy.core.plugin').values(spec, 'opts', false)
      T.eq(opts.format_on_save(bufnr).timeout_ms, 1234)
    end,
  },
  {
    name = 'trailing whitespace is kept in Markdown and diffs and removed elsewhere',
    run = function()
      local cases = {
        { 'markdown', { 'hard break  ', 'next line' }, { 'hard break  ', 'next line' } },
        { 'diff', { ' ', '-old' }, { ' ', '-old' } },
        { 'text', { 'hello   ' }, { 'hello' } },
      }
      for _, case in ipairs(cases) do
        vim.cmd('enew')
        vim.bo.filetype = case[1]
        vim.api.nvim_buf_set_lines(0, 0, -1, false, case[2])
        -- Run only Cosmic's save hook so formatters installed on the machine don't affect the result.
        vim.api.nvim_exec_autocmds('BufWritePre', { group = 'CosmicNvimEditor', buffer = 0 })
        T.eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), case[3], case[1])
      end
    end,
  },
}
