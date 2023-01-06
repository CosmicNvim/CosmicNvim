local user_config = require('cosmic.core.user')
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  config = function()
    require('cosmic.plugins.telescope.config')
  end,
  init = function()
    -- normal mappings
    require('cosmic.plugins.telescope.mappings').init()

    user_config.lsp.add_on_attach_mapping(function(client, bufnr)
      local map = require('cosmic.utils').map
      local function buf_map(mode, lhs, rhs)
        map(mode, lhs, rhs, {
          buffer = bufnr,
        })
      end

      buf_map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
      buf_map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>')
      buf_map('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>')
      buf_map('n', 'gr', '<cmd>Telescope lsp_references<cr>')
      buf_map('n', '<leader>ge', '<cmd>Telescope diagnostics bufnr=0<cr>')
      buf_map('n', '<leader>wd', '<cmd>Telescope diagnostics<cr>')
    end)
  end,
  cmd = { 'Telescope' },
  keys = {
    {
      '<leader>ff',
      '<cmd>lua require("cosmic.plugins.telescope.mappings").project_files()<cr>',
      desc = 'Project find files',
    },
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'telescope'),
}
