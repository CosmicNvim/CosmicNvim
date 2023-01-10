local map = require('cosmic.utils').map
local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

M.init = function()
  -- navigation
  map(
    'n',
    '<leader>ff',
    '<cmd>lua require("cosmic.plugins.telescope.mappings").project_files()<cr>',
    { desc = 'Find git files' }
  )
  map('n', '<leader>fp', ':Telescope find_files<cr>', { desc = 'Find file' })
  map('n', '<leader>fk', ':Telescope buffers<cr>', { desc = 'Find buffer' })
  map('n', '<leader>fs', ':Telescope live_grep<cr>', { desc = 'Live grep' })
  map('n', '<leader>fw', ':Telescope grep_string<cr>', { desc = 'Grep string' })

  -- git navigation
  map('n', '<leader>ggc', ':Telescope git_commits<cr>', { desc = 'Git commits' })
  map('n', '<leader>ggs', ':Telescope git_status<cr>', { desc = 'Git status' })
end

return M
