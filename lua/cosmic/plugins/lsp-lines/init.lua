local u = require('cosmic.utils')
local user_config = require('cosmic.core.user')
local vt_config = require('cosmic.lsp.diagnostics.config')
local map = require('cosmic.utils').map
local is_plugin_enabled = user_config.plugins.lsp_lines.enable_on_start
local function toggle()
  if is_plugin_enabled then
    vim.diagnostic.config(u.merge(vt_config, {
      virtual_text = false,
      virtual_lines = true,
    }))
  else
    vim.diagnostic.config(u.merge(vt_config, {
      virtual_lines = false,
    }))
  end
  is_plugin_enabled = not is_plugin_enabled
end

return {
  url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  keys = {
    {
      '<leader>ltl',
      toggle,
      desc = 'Toggle LSP Lines',
    },
  },
  config = function()
    -- init lsp_lines
    require('lsp_lines').setup()
    -- run once to properly show/hide based on user config
    toggle()
    -- map for toggling lines
    map('n', '<leader>ltl', '', {
      callback = toggle,
      desc = 'Toggle LSP Lines',
    })
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lsp_lines'),
}
