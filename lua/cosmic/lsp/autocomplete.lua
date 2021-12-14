local utils = require('cosmic-ui.utils')
local cosmic_ui = require('cosmic-ui')
local M = {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local get_formatting = function()
  local ok, _ = pcall(require, 'lspkind')
  if not ok then
    return {}
  end

  return {
    format = require('lspkind').cmp_format({
      with_text = true,
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[VimApi]',
        path = '[path]',
        luasnip = '[snip]',
      },
    }),
  }
end

M.init = function(provider_opts)
  local cmp = require('cmp')
  -- @TODO: support for vsnip, ultisnips
  local default_cmp_opts = {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- disabled for autopairs mapping
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require('luasnip').expand_or_jumpable() then
          require('luasnip').expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require('luasnip').jumpable(-1) then
          require('luasnip').jump(-1)
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
    },
    documentation = {
      border = cosmic_ui.get_border(),
      winhighlight = 'FloatBorder:FloatBorder,Normal:Normal',
    },
    experimental = {
      ghost_text = true,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'luasnip' },
      { name = 'path' },
    }),
    formatting = get_formatting(),
  }

  vim.cmd([[
  autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }
  ]])

  local opts = utils.merge(default_cmp_opts, provider_opts or {})

  cmp.setup(opts)

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
    },
  })
end

return M
