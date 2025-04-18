local user_config = require('cosmic.core.user')
local lsp_utils = require('cosmic.utils.lsp')
return {
  'williamboman/mason-lspconfig.nvim',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'mason-lspconfig'),
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    -- set up lsp servers
    local u = require('cosmic.utils')
    local default_config = require('cosmic.lsp.servers.defaults')
    local lspconfig = require('lspconfig')

    local start_server = function(server)
      local server_config = default_config

      -- set up default cosmic options
      local ok, cosmic_server_config = pcall(require, 'cosmic.lsp.servers.' .. server)
      if ok then
        server_config = u.merge(server_config, cosmic_server_config)
      end

      -- override options if user defines them
      if type(user_config.lsp.servers[server]) == 'table' and user_config.lsp.servers[server].opts ~= nil then
        server_config = u.merge(server_config, user_config.lsp.servers[server].opts)
      end

      lspconfig[server].setup(server_config)
    end

    for config_server, config_opt in pairs(user_config.lsp.servers) do
      if not config_opt == false then
        start_server(config_server)
      end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('cosmic_lsp_attach_disable_format', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if not lsp_utils.can_client_format_on_save(client) then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          vim.notify(string.format('Disabled LSP formatting based on config: [%s]', client.name))
        end
      end,
      desc = 'LSP: disable formatting for user specified lsps',
    })
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig', lazy = true },
    {
      'williamboman/mason.nvim',
      opts = {
        ui = {
          border = user_config.border,
        },
      },
    },
  },
}
