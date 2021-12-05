local M = {}

M.highlight = function(group, bg, fg, gui)
  if gui ~= nil and gui ~= '' then
    vim.api.nvim_command(('hi %s guibg=%s guifg=%s gui=%s'):format(group, bg, fg, gui))
  elseif bg == nil then
    vim.api.nvim_command(('hi %s guifg=%s'):format(group, fg))
  elseif fg == nil then
    vim.api.nvim_command(('hi %s guibg=%s'):format(group, bg))
  else
    vim.api.nvim_command(('hi %s guibg=%s guifg=%s'):format(group, bg, fg))
  end
end

M.set_highlight = function(hi, colors)
  local hi_str = ''

  for k, v in pairs(colors) do
    hi_str = hi_str .. k .. '=' .. v .. ' '
  end

  vim.cmd(('hi %s %s'):format(hi, hi_str))
end

M.get_highlight = function(hi)
  local hi_str = vim.api.nvim_command_output(('hi %s'):format(hi))

  local colors = {}
  for key, val in string.gmatch(hi_str, '(%w+)=(%S+)') do
    colors[key] = val
  end

  return colors
end

return M
