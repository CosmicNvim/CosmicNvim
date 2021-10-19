local M = {}

local function get_basename(file)
  return file:match('^.+/(.+)$')
end

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.get_git_root()
  local git_dir = require('galaxyline.providers.vcs').get_git_dir()
  if not git_dir then
    return 'not a git dir '
  end

  local git_root = git_dir:gsub('/.git/?$', '')
  return get_basename(git_root) .. ' '
end

function M.split(str, sep)
  local res = {}
  for w in str:gmatch('([^' .. sep .. ']*)') do
    if w ~= '' then
      table.insert(res, w)
    end
  end
  return res
end

function M.highlight(group, bg, fg, gui)
  if gui ~= nil and gui ~= '' then
    vim.api.nvim_command(string.format('hi %s guibg=%s guifg=%s gui=%s', group, bg, fg, gui))
  else
    vim.api.nvim_command(string.format('hi %s guibg=%s guifg=%s', group, bg, fg))
  end
end

return M
