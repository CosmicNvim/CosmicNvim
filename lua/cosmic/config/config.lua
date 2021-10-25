-- Override Cosmic configuration options

--[[
local config = {}

config.lsp = {

  -- true/false or table of filetypes {'.ts', '.js',}
  format_on_save = false,

  servers = {

    -- enable/disable server
    eslint = false,

    -- enable non-default servers (todo: support for custom server configs)
    rust_analyzer = true,

    efm = {
      -- specifc to efm, e.g. 'eslint', 'prettier', 'lua'
      disable_formatters = {},
    },

   tsserver = {
      -- disable formatting all together
      format = false,
   }

  }
}

return config
]]
