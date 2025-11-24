local user_config = require('cosmic.core.user')
return {
  'williamboman/mason-lspconfig.nvim',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'mason-lspconfig'),
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    -- set up lsp servers
    local u = require('cosmic.utils')
    local default_config = require('cosmic.lsp.servers.defaults')

    for user_server, config_opt in pairs(user_config.lsp.servers) do
      if not config_opt == false then
        local server_config = default_config

        -- set up default cosmic options
        local ok, cosmic_server_config = pcall(require, 'cosmic.lsp.servers.' .. user_server)
        if ok then
          server_config = u.merge(server_config, cosmic_server_config)
        end

        -- override options if user defines them
        if type(user_config.lsp.servers[user_server]) == 'table' and user_config.lsp.servers[user_server].opts ~= nil then
          server_config = u.merge(server_config, user_config.lsp.servers[user_server].opts)
        end

        vim.lsp.config(user_server, server_config)
        vim.lsp.enable(user_server)
      end
    end
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig',  lazy = true },
    { 'williamboman/mason.nvim' , lazy = true, opts = {} },
  },
}
