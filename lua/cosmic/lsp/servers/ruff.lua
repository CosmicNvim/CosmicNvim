return {
  settings = {
    logLevel = 'debug',
  },
  on_attach = function(client)
    if client.name == 'ruff' then
      -- Disable hover in favor of basedpyright
      client.server_capabilities.hoverProvider = false
    end
  end
}
