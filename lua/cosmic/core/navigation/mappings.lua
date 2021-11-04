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
  map('n', '<leader>ff', '<cmd>lua require("cosmic.core.navigation.mappings").project_files()<cr>')
  map('n', '<leader>fp', ':Telescope find_files<cr>')
  map('n', '<leader>fk', ':Telescope buffers<cr>')
  map('n', '<leader>fs', ':Telescope live_grep<cr>')

  -- git navigation
  map('n', '<leader>ggc', ':Telescope git_commits<cr>')
  map('n', '<leader>ggs', ':Telescope git_status<cr>')

  -- quickfix navigation
  map('n', '<leader>cp', ':cprev<cr>')
  map('n', '<leader>cn', ':cnext<cr>')

  -- buffer navigation
  map('n', '<leader>bp', ':bprev<cr>')
  map('n', '<leader>bn', ':bnext<cr>')

  -- tab navigation
  map('n', '<leader>tp', ':tprev<cr>')
  map('n', '<leader>tn', ':tnext<cr>')
end

return M
