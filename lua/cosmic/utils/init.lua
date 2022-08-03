local M = {}
local augroup_name = 'CosmicNvimUtils'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

function M.map(mode, lhs, rhs, opts)
  local defaults = {
    silent = true,
    noremap = true,
  }
  vim.keymap.set(mode, lhs, rhs, M.merge(defaults, opts or {}))
end

function M.merge_list(tbl1, tbl2)
  for _, v in ipairs(tbl2) do
    table.insert(tbl1, v)
  end
  return tbl1
end

function M.merge(...)
  return vim.tbl_deep_extend('force', ...)
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

function M.get_active_lsp_client_names()
  local active_clients = vim.lsp.get_active_clients()
  local client_names = {}
  for _, client in pairs(active_clients or {}) do
    local buf = vim.api.nvim_get_current_buf()
    -- only return attached buffers
    if vim.lsp.buf_is_attached(buf, client.id) then
      table.insert(client_names, client.name)
    end
  end

  if not vim.tbl_isempty(client_names) then
    table.sort(client_names)
  end
  return client_names
end

local function unload(module_pattern, reload)
  reload = reload or false
  for module, _ in pairs(package.loaded) do
    if module:match(module_pattern) then
      package.loaded[module] = nil
      if reload then
        require(module)
      end
    end
  end
end

local function clear_cache()
  vim.cmd(':LuaCacheClear')
end

function M.post_reload(msg)
  local Logger = require('cosmic.utils.logger')
  unload('cosmic.utils', true)
  unload('cosmic.theme', true)
  unload('cosmic.plugins.statusline', true)
  msg = msg or 'User config reloaded!'
  Logger:log(msg)
end

function M.reload_user_config_sync()
  clear_cache()
  unload('cosmic.core.user', true)
  unload('cosmic.core.pluginsInit', true)
  vim.api.nvim_create_autocmd('User PackerComplete', {
    callback = function()
      M.post_reload()
    end,
    group = group,
    once = true,
  })
  vim.cmd(':PackerSync')
end

function M.reload_user_config(compile)
  compile = compile or false
  unload('cosmic.core.user', true)
  if compile then
    vim.api.nvim_create_autocmd('User PackerCompileDone', {
      callback = function()
        M.post_reload()
      end,
      group = group,
      once = true,
    })
    vim.cmd(':PackerCompile')
  end
end

function M.get_install_dir()
  local config_dir = os.getenv('COSMICNVIM_INSTALL_DIR')
  if not config_dir then
    return vim.fn.stdpath('config')
  end
  return config_dir
end

-- update instance of CosmicNvim
function M.update()
  local Logger = require('cosmic.utils.logger')
  local Job = require('plenary.job')
  local path = M.get_install_dir()
  local errors = {}

  Job
    :new({
      command = 'git',
      args = { 'pull', '--ff-only' },
      cwd = path,
      on_start = function()
        Logger:log('Updating...')
      end,
      on_exit = function()
        if vim.tbl_isempty(errors) then
          Logger:log('Updated! Running CosmicReloadSync...')
          M.reload_user_config_sync()
        else
          table.insert(errors, 1, 'Something went wrong! Please pull changes manually.')
          table.insert(errors, 2, '')
          Logger:error('Update failed!', { timeout = 30000 })
        end
      end,
      on_stderr = function(_, err)
        table.insert(errors, err)
      end,
    })
    :sync()
end

return M
