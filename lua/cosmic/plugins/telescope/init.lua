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
      local buf_map = require('cosmic.utils').create_buf_map(bufnr)

      buf_map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { desc = 'Go to definition' })
      buf_map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Go to implementation' })
      buf_map('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Go to type definition' })
      buf_map('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'Go to reference' })

      buf_map('n', '<leader>ldb', '<cmd>Telescope diagnostics bufnr=0<cr>', { desc = 'Show buffer diagnostics' })
      buf_map('n', '<leader>ldw', '<cmd>Telescope diagnostics<cr>', { desc = 'Workspace diagnostics' })
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
