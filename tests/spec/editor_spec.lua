local T = require('tests.harness')

return {
  {
    name = 'resizing keeps the current tab page and equalizes every tab page',
    run = function()
      vim.cmd('vsplit | vertical resize 10 | tabnew | vsplit | vertical resize 10 | tabfirst')
      vim.api.nvim_exec_autocmds('VimResized', {})
      T.eq(vim.fn.tabpagenr(), 1, 'current tab page')
      for index, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        local widths = vim.tbl_map(vim.api.nvim_win_get_width, vim.api.nvim_tabpage_list_wins(tabpage))
        T.truthy(math.abs(widths[1] - widths[2]) <= 1, ('tab %d widths %s'):format(index, vim.inspect(widths)))
      end
    end,
  },
  {
    name = 'Tree-sitter indent is only used for languages with indent queries',
    run = function()
      -- Both parsers ship with Neovim. Installing a parser through nvim-treesitter adds its queries,
      -- but tests install none, so neither language starts with indent queries.
      vim.cmd('enew | setfiletype vim')
      T.eq(vim.bo.indentexpr, 'GetVimIndent()', 'vim without indent queries')

      local queries = T.tmpdir()
      T.write(queries .. '/queries/lua/indents.scm', { '(block) @indent.begin' })
      vim.opt.runtimepath:prepend(queries)
      vim.cmd('enew | setfiletype lua')
      T.eq(vim.bo.indentexpr, "v:lua.require'nvim-treesitter'.indentexpr()", 'lua with indent queries')
    end,
  },
  {
    name = 'diagnostic line number highlights exist',
    run = function()
      for severity, group in pairs(vim.diagnostic.config().signs.numhl) do
        T.eq(vim.fn.hlexists(group), 1, ('%s highlight %s'):format(vim.diagnostic.severity[severity], group))
      end
    end,
  },
  {
    name = 'auto-session options use current names',
    run = function()
      require('lazy').load({ plugins = { 'auto-session' } })
      T.eq(require('auto-session.config').has_old_config, false)
    end,
  },
}
