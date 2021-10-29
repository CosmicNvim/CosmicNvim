local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
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

function M.get_relative_path(path)
  local split_path = M.split(path, '/')
  local split_cwd = M.split(vim.fn.getcwd(), '/')
  local curr_dir = split_cwd[#split_cwd]
  local nice_path = ''

  local ok = false
  for _, dir in ipairs(split_path) do
    if dir == curr_dir then
      ok = true
    end
    if ok then
      nice_path = nice_path .. '/' .. dir
    end
  end

  return '.' .. nice_path
end

return M
