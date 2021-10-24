local default_config = require('cosmic.lsp.providers.defaults')
local config = require('cosmic.config')
local lsp_installer = require('nvim-lsp-installer')

lsp_installer.settings({
  ui = {
    keymaps = {
      -- Keymap to expand a server in the UI
      toggle_server_expand = 'i',
      -- Keymap to install a server
      install_server = '<CR>',
      -- Keymap to reinstall/update a server
      update_server = 'u',
      -- Keymap to uninstall a server
      uninstall_server = 'x',
    },
  },
})

-- initial default serverse
local requested_servers = {
  'eslint',
  'efm',
  'tsserver',
  'sumneko_lua',
  'jsonls',
  'cssls',
  'html',
  -- 'intelephense',
  -- 'pyright',
  -- 'gopls',
}

-- add servers set in config to requested_servers table
for config_server in pairs(config.lsp.servers) do
  if requested_servers[config_server] == nil then
    table.insert(requested_servers, config_server)
  end
end

-- go through requested_servers and ensure installation
local lsp_installer_servers = require('nvim-lsp-installer.servers')
for server in pairs(requested_servers) do
  local requested_server = requested_servers[server]

  local ok, serv = lsp_installer_servers.get_server(requested_server)
  if ok then
    if not serv:is_installed() then
      serv:install()
    end
  end
end

--[[ Auto-format *.rs (rust) files prior to saving them
     autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000) ]]

lsp_installer.on_server_ready(function(server)
  local opts = default_config
  --[[ if config.lsp.servers[server.name] == nil then
    opts.autostart = false
  end ]]

  if server.name == 'sumneko_lua' then
    opts = vim.tbl_deep_extend('force', opts, require('cosmic.lsp.providers.lua'))
  elseif server.name == 'tsserver' then
    opts = vim.tbl_deep_extend('force', opts, require('cosmic.lsp.providers.tsserver'))
  elseif server.name == 'efm' then
    opts = vim.tbl_deep_extend('force', opts, require('cosmic.lsp.providers.efm'))
  elseif server.name == 'jsonls' then
    opts = vim.tbl_deep_extend('force', opts, require('cosmic.lsp.providers.jsonls'))
  elseif server.name == 'eslint' then
    opts = vim.tbl_deep_extend('force', opts, require('cosmic.lsp.providers.eslint'))
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
