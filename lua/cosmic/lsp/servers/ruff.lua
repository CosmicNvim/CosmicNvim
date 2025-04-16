local defaults = require('cosmic.lsp.servers.defaults')
return {
  settings = {
    logLevel = 'debug',
  },
  on_attach = function(client, bufnr)
    defaults.on_attach(client, bufnr)
    if client.name == 'ruff' then
      -- Disable hover in favor of basedpyright
      client.server_capabilities.hoverProvider = false
      -- Disable hover in favor of ruff + conform
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end
}
