-- Override Cosmic configuration options

--[[

local config = {}

config.statusline = {
  main_icon = '★',
}

config.lsp = {

  -- true/false or table of filetypes {'.ts', '.js',}
  format_on_save = true,

  servers = {

    -- enable/disable server + formatting
    eslint = false,

    -- enable non-default servers (todo: support for custom server configs)
    rust_analyzer = true,

    tsserver = {
      -- disable formatting
      format = false,
    },

    efm = {
      -- specifc to efm, e.g. 'eslint', 'prettier', 'stylua'
      disable_formatters = {'eslint'},
    },
  },
}

return config

]]
local config = {
  lsp = {
    format_on_save = true,
    servers = {
      eslint = {
        format = false,
      },
      efm = {
        -- specifc to efm, e.g. 'eslint', 'prettier', 'stylua'
        disable_formatters = {'eslint'},
      },
    }
  }
}
return config
