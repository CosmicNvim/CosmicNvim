local M = {}
local augroup_name = 'CosmicNvimUtils'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local function clear_cache()
  vim.cmd(':LuaCacheClear')
end

local function get_install_dir()
  local config_dir = os.getenv('COSMICNVIM_INSTALL_DIR')
  if not config_dir then
    return vim.fn.stdpath('config')
  end
  return config_dir
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

local function post_reload(msg)
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
      post_reload()
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
        post_reload()
      end,
      group = group,
      once = true,
    })
    vim.cmd(':PackerCompile')
  end
end

-- update instance of CosmicNvim
function M.update()
  local Logger = require('cosmic.utils.logger')
  local Job = require('plenary.job')
  local path = get_install_dir()
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
