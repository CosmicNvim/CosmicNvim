local M = {}

local api = vim.api
local lsp = vim.lsp
local buf, win

function M.rename()
  local icons = require('cosmic.core.theme.icons')
  local utils = require('cosmic.utils')
  local config = require('cosmic.config')
  local highlight = utils.highlight
  local prompt_str = ' ' .. icons.folder.arrow_closed .. ' '
  local map_opts = { noremap = true, silent = true }
  local opts = {
    style = 'minimal',
    border = 'single',
    relative = 'cursor',
    width = 25,
    height = 1,
    row = 1,
    col = 1,
  }
  buf, win = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  api.nvim_open_win(buf, true, opts)
  api.nvim_win_set_option(win, 'scrolloff', 0)
  api.nvim_win_set_option(win, 'sidescrolloff', 0)
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_option(buf, 'buftype', 'prompt')

  local _, colors = pcall(require, 'cosmic.core.theme.colors')
  if colors then
    api.nvim_buf_add_highlight(buf, -1, 'LspRenamePrompt', 0, 0, #prompt_str)
    highlight('LspRenamePrompt', 'None', colors.selection_caret)
  end

  vim.fn.prompt_setprompt(buf, prompt_str)

  vim.api.nvim_command('startinsert!')
  api.nvim_buf_set_keymap(buf, 'i', '<esc>', '<CMD>stopinsert <BAR> q!<CR>', map_opts)
  api.nvim_buf_set_keymap(
    buf,
    'i',
    '<CR>',
    "<CMD>stopinsert <BAR> lua require('cosmic.core.theme.ui')._rename()<CR>",
    map_opts
  )

  local function handler(...)
    local result
    local method
    local err = select(1, ...)
    local is_new = not select(4, ...) or type(select(4, ...)) ~= 'number'
    if is_new then
      method = select(3, ...).method
      result = select(2, ...)
    else
      method = select(2, ...)
      result = select(3, ...)
    end

    if config.lsp.rename_notification then
      if err then
        vim.notify(("Error running LSP query '%s': %s"):format(method, err), vim.log.levels.ERROR)
        return
      end

      -- echo the resulting changes
      local new_word = ''
      if result and result.changes then
        local msg = ''
        for f, c in pairs(result.changes) do
          new_word = c[1].newText
          msg = msg .. ('%d changes -> %s'):format(#c, utils.get_relative_path(f)) .. '\n'
        end
        local currName = vim.fn.expand('<cword>')
        msg = msg:sub(1, #msg - 1)
        vim.notify(msg, vim.log.levels.INFO, { title = ('Rename: %s -> %s'):format(currName, new_word) })
      end
    end

    vim.lsp.handlers[method](...)
  end

  function M._rename()
    local new_name = vim.trim(vim.fn.getline('.'):sub(5, -1))
    vim.cmd([[q!]])
    local params = lsp.util.make_position_params()
    local curr_name = vim.fn.expand('<cword>')
    if not (new_name and #new_name > 0) or new_name == curr_name then
      return
    end
    params.newName = new_name
    lsp.buf_request(0, 'textDocument/rename', params, handler)
  end
end

return M
