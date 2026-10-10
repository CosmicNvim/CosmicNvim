local T = require('tests.harness')

return {
  {
    name = 'after/lsp configs only use fields vim.lsp.config understands',
    run = function()
      for _, file in ipairs(vim.fn.glob(T.root .. '/after/lsp/*.lua', false, true)) do
        local name = vim.fn.fnamemodify(file, ':t')
        local config = dofile(file)
        -- on_new_config and root_dir(fname) were nvim-lspconfig setup() APIs; vim.lsp.config ignores them.
        T.eq(config.on_new_config, nil, name .. ' on_new_config')
        if type(config.root_dir) == 'function' then
          T.eq(debug.getinfo(config.root_dir, 'u').nparams, 2, name .. ' root_dir(bufnr, on_dir)')
        end
      end
    end,
  },
  {
    name = 'jsonls adds SchemaStore schemas without changing the catalog',
    run = function()
      local catalog = #require('schemastore').json.schemas()
      T.truthy(catalog > 100, 'SchemaStore catalog size')
      for _ = 1, 2 do
        local config = vim.deepcopy(vim.lsp.config.jsonls)
        config.settings.json.schemas = { { name = 'mine', fileMatch = { 'mine.json' }, url = 'file:///mine.json' } }
        config.before_init({}, config)
        T.eq(#config.settings.json.schemas, catalog + 1, 'schemas sent to jsonls')
        T.eq(config.settings.json.schemas[catalog + 1].name, 'mine', 'user schema kept')
      end
      T.eq(#require('schemastore').json.schemas(), catalog, 'SchemaStore catalog after two clients')
    end,
  },
  {
    name = 'basedpyright uses a project .venv that is not activated',
    run = function()
      local root = T.tmpdir()
      local python = root .. '/.venv/bin/python'
      T.write(python, { '#!/bin/sh' })
      vim.uv.fs_chmod(python, 493) -- 0755
      local config = vim.deepcopy(vim.lsp.config.basedpyright)
      config.root_dir = root
      config.before_init({}, config)
      T.eq(config.settings.python.pythonPath, python, 'pythonPath')
    end,
  },
  {
    name = 'inlay hint toggle only changes the current buffer',
    config = { lsp = { servers = { cosmic_fake = T.fake_server_config({ inlay_hints = true }) } } },
    run = function()
      local dir = T.tmpdir()
      local other = T.open_with_fake_server(dir .. '/other.cosmictest')
      local current = T.open_with_fake_server(dir .. '/current.cosmictest')
      T.truthy(vim.fn.maparg(' lh', 'n') ~= '', '<leader>lh mapped for servers with inlay hints')
      require('cosmic.utils.lsp').toggle_inlay_hints()
      T.eq(vim.lsp.inlay_hint.is_enabled({ bufnr = current }), true, 'current buffer')
      T.eq(vim.lsp.inlay_hint.is_enabled({ bufnr = other }), false, 'other buffer')
    end,
  },
}
