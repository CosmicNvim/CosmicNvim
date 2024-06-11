local M = {}
local map = require('cosmic.utils').set_keymap
local Terminal = require('toggleterm.terminal').Terminal

function M.new_terminal()
  local terminal = Terminal:new()
  terminal:toggle()
end

function M.set_terminal_keymaps() end

return M
