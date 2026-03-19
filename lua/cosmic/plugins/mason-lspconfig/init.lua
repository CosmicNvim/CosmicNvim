local user_config = require('cosmic.core.user')

---@return string[]
local function get_enabled_servers()
  local servers = vim.tbl_keys(user_config.lsp.resolved_servers)
  table.sort(servers)
  return servers
end

-- set up lsp servers
return {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  config = function()
    local enabled_servers = get_enabled_servers()

    for server_name, server_config in pairs(user_config.lsp.resolved_servers) do
      vim.lsp.config(server_name, vim.deepcopy(server_config))
    end

    require('mason-lspconfig').setup({
      ensure_installed = enabled_servers,
      automatic_enable = false,
    })

    -- Enable servers after registering user config so Mason shims do not
    -- override non-table fields such as `before_init` or `cmd`.
    for server_name in pairs(user_config.lsp.resolved_servers) do
      vim.lsp.enable(server_name)
    end
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig', lazy = true },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
  },
}
