local map = require('cosmic.utils').map
local M = {}

function M.init()
  map('n', '<leader>p', ':Telescope find_files<CR>', { noremap = true })
  map('n', '<leader>f', ':Telescope git_files<CR>', { noremap = true })
  map('n', '<leader>k', ':Telescope buffers<CR>', { noremap = true })
  map('n', '<leader>s', ':Telescope live_grep<CR>', { noremap = true })
  map('n', '<leader>gc', ':Telescope git_commits<CR>', { noremap = true })
  map('n', '<leader>gs', ':Telescope git_status<CR>', { noremap = true })
end

function M.mappings()
  local actions = require('telescope.actions')
  local normal = {
    n = {
      ['Q'] = actions.smart_add_to_qflist + actions.open_qflist,
      ['q'] = actions.smart_send_to_qflist + actions.open_qflist,
      ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
      ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
      ['v'] = actions.file_vsplit,
      ['s'] = actions.file_split,
      ['<cr>'] = actions.file_edit,
    },
  }

  return normal
end

return M
