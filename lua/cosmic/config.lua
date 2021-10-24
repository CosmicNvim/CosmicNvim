local config = {
  lsp = {
    format_on_save = true,
    servers = {
      eslint = nil,
      efm = {
        -- disable_formatters = {'eslint'}
      }
    }
  }
}

return config
