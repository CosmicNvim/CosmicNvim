-- Override Cosmic configuration options

--[[

local config = {}

-- statusline settings
config.statusline = {
  main_icon = '★',
}

config.treesitter = {
  ensure_installed = {
    'typescript',
    'javascript',
    'tsx',
    'html',
    'css',
    'lua',
    'json',
    'scss',
  },
}

config.lsp = {

  -- true/false or table of filetypes {'.ts', '.js',}
  format_on_save = true,

  -- set to false to disable rename notification
  rename_notification = false,

  -- see :h vim.diagnostic.config for all diagnostic configuration options
  diagnostic = {

    -- disable diagnostic virtual text
    virtual_text = false,

    -- disable diagnostic signs
    signs = false,

    -- enable diagnostic update on insert
    update_in_insert = true,

    -- disable underline for diagnostic
    underline = false,

  },

  servers = {

    -- enable/disable server + formatting
    eslint = false,

    -- enable non-default servers, use default lsp config
    -- check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers
    rust_analyzer = true,

    tsserver = {
      -- disable formatting
      format = false,
      -- OR add/override server options
      opts = {
        on_attach = function(client, bufnr) end,
        flags = {
          debounce_text_changes = 150,
        }
      }
    },

    efm = {
      -- specifc to efm, e.g. 'eslint', 'prettier', 'stylua'
      disable_formatters = {'eslint'},
    },

  },
}

return config

]]
