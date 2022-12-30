local user_config = require('cosmic.core.user')
return {
  'williamboman/mason-lspconfig.nvim',
  config = function()
    require('mason').setup({
      ui = {
        border = user_config.border,
      },
    })
    require('mason-lspconfig').setup({
      ensure_installed = user_config.lsp.ensure_installed,
    })

    -- set up lsp servers
    local u = require('cosmic.utils')
    local default_config = require('cosmic.lsp.providers.defaults')
    local lspconfig = require('lspconfig')

    -- initial default servers
    -- by default tsserver/ts_utils and null_ls are enabled
    local requested_servers = {}

    -- get disabled servers from config
    local disabled_servers = {}
    for config_server, config_opt in pairs(user_config.lsp.servers) do
      -- null ls doesn't need to be setup by lspconfig
      if not config_server == 'null_ls' then
        print(config_server)
      end

      --[[ print(config_server) ]]
      if config_opt == false or config_server == 'null_ls' then
        table.insert(disabled_servers, config_server)
      elseif not vim.tbl_contains(requested_servers, config_server) then
        -- add additonally defined servers to be installed
        table.insert(requested_servers, config_server)
      end
    end

    for _, requested_server in pairs(requested_servers) do
      local opts = default_config

      -- disable server if config disabled server list says so
      opts.autostart = true
      if vim.tbl_contains(disabled_servers, requested_server) then
        opts.autostart = false
      end

      -- set up default cosmic options
      if requested_server == 'tsserver' then
        opts = u.merge(opts, require('cosmic.lsp.providers.tsserver'))
      elseif requested_server == 'jsonls' then
        opts = u.merge(opts, require('cosmic.lsp.providers.jsonls'))
      elseif requested_server == 'pyright' then
        opts = u.merge(opts, require('cosmic.lsp.providers.pyright'))
      elseif requested_server == 'sumneko_lua' then
        opts = u.merge(opts, require('cosmic.lsp.providers.sumneko_lua'))
      end

      -- override options if user definds them
      if type(user_config.lsp.servers[requested_server]) == 'table' then
        if user_config.lsp.servers[requested_server].opts ~= nil then
          opts = u.merge(opts, user_config.lsp.servers[requested_server].opts)
        end
      end

      lspconfig[requested_server].setup(opts)
    end
  end,
  dependencies = {
    'williamboman/mason.nvim',
  },
  event = 'VeryLazy',
}
