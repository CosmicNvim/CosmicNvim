return {
  'williamboman/mason-lspconfig.nvim',
  config = function()
    local user_config = require('cosmic.core.user')
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

    local start_server = function(server)
      -- null_ls doesn't need/can't to be started via lspconfig
      if server == 'null_ls' then
        return
      end

      local opts = default_config

      -- set up default cosmic options
      if server == 'tsserver' then
        opts = u.merge(opts, require('cosmic.lsp.providers.tsserver'))
      elseif server == 'jsonls' then
        opts = u.merge(opts, require('cosmic.lsp.providers.jsonls'))
      elseif server == 'pyright' then
        opts = u.merge(opts, require('cosmic.lsp.providers.pyright'))
      elseif server == 'lua_ls' then
        opts = u.merge(opts, require('cosmic.lsp.providers.lua_ls'))
      end

      -- override options if user definds them
      if type(user_config.lsp.servers[server]) == 'table' then
        if user_config.lsp.servers[server].opts ~= nil then
          opts = u.merge(opts, user_config.lsp.servers[server].opts)
        end
      end

      lspconfig[server].setup(opts)
    end

    for config_server, config_opt in pairs(user_config.lsp.servers) do
      if not config_opt == false then
        start_server(config_server)
      end
    end
  end,
  dependencies = {
    'williamboman/mason.nvim',
  },
  event = 'BufEnter',
}
