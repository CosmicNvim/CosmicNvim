local user_config = require('cosmic.core.user')
return {
  event = 'VeryLazy',
  url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  config = function()
    local u = require('cosmic.utils')
    local map = require('cosmic.utils').map
    local vt_config = require('cosmic.lsp.diagnostics.config')
    local is_plugin_enabled = user_config.plugins.lsp_lines.enable_on_start

    -- init lsp_lines
    require('lsp_lines').setup()

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

    -- run once to properly show/hide based on user config
    toggle()

    -- map for toggling lines
    map('n', '<leader>ld', '', {
      callback = toggle,
    })
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'lsp_lines'),
}
