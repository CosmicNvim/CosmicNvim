-- Override Cosmic configuration options

--[[ local config = {}
config.lsp = {
  format_on_save = true,
  servers = {
    eslint = false,
    efm = {
      format = false, -- disable formatting all together
      disable_formatters = {}, -- e.g. 'eslint', 'prettier', 'lua'
    },
   tsserver = {
      format = false,
   }
  }
}

return config
 ]]
