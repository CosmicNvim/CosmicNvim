local user_config = require('cosmic.core.user')

-- set up lsp servers
return {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  config = function()
    for server_name, server_config in pairs(user_config.lsp.resolved_servers) do
      vim.lsp.config(server_name, vim.deepcopy(server_config))
      vim.lsp.enable(server_name)
    end
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig', lazy = true },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
  },
}
