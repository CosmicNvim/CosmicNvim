local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
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
    vim.api.nvim_command(('hi %s guibg=%s guifg=%s gui=%s'):format(group, bg, fg, gui))
  elseif bg == nil then
    vim.api.nvim_command(('hi %s guifg=%s'):format(group, fg))
  else
    vim.api.nvim_command(('hi %s guibg=%s guifg=%s'):format(group, bg, fg))
  end
end

function M.get_relative_path(file_path)
  local plenary_path = require('plenary.path')
  local parsed_path, _ = file_path:gsub('file://', '')
  local path = plenary_path:new(parsed_path)
  local relative_path = path:make_relative(vim.fn.getcwd())
  return './' .. relative_path
end

return M
