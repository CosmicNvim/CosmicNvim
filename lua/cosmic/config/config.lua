-- Override Cosmic configuration options

--[[

local config = {}

config.statusline = {
  main_icon = '★',
}

config.lsp = {

  -- true/false or table of filetypes {'.ts', '.js',}
  format_on_save = true,

  diagnostic = {
    -- disable diagnostic virtual text (see :h vim.diagnostic.config for all options)
    virtual_text = false,

    -- disable diagnostic signs (see :h vim.diagnostic.config for all options)
    signs = false,

    -- enable diagnostic update on insert
    update_in_insert = true,

    -- disable underline for diagnostic
    underline = false,
  },

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
