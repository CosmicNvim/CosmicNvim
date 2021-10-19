local default_config = require('cosmic.lsp.providers.defaults')
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

lsp_installer.on_server_ready(function(server)
  local opts = default_config

  if server.name == 'sumneko_lua' then
    local config = require('cosmic.lsp.providers.lua')
    opts = vim.tbl_deep_extend('force', opts, config)
  elseif server.name == 'tsserver' then
    local config = require('cosmic.lsp.providers.tsserver')
    opts = vim.tbl_deep_extend('force', opts, config)
  elseif server.name == 'efm' then
    local config = require('cosmic.lsp.providers.efm')
    opts = vim.tbl_deep_extend('force', opts, config)
  elseif server.name == 'jsonls' then
    local config = require('cosmic.lsp.providers.jsonls')
    opts = vim.tbl_deep_extend('force', opts, config)
  elseif server.name == 'eslint' then
    local config = require('cosmic.lsp.providers.eslint')
    opts = vim.tbl_deep_extend('force', opts, config)
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
