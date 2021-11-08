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

function M.get_active_lsp_client_names()
  local active_clients = vim.lsp.get_active_clients()
  local client_names = {}
  for i, client in pairs(active_clients) do
    table.insert(client_names, i, client.name)
  end

  table.sort(client_names)
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

function M.reload_user_config()
  unload('cosmic.config', true)
end

function M.reload_cosmic()
  unload('cosmic')
  require('cosmic')
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
  local Job = require('plenary.job')
  local path = M.get_install_dir()
  local errors = {}

  Job
    :new({
      command = 'git',
      args = { 'pull', '--ff-only' },
      cwd = path,
      on_start = function()
        vim.notify('Updating...', vim.log.levels.INFO, {
          title = 'CosmicNvim',
        })
      end,
      on_exit = function()
        if vim.tbl_isempty(errors) then
          vim.notify(
            'Please restart CosmicNvim and run `:PackerSync`',
            vim.log.levels.INFO,
            { title = 'CosmicNvim Updated!', timeout = 30000 }
          )
        else
          table.insert(errors, 1, 'Something went wrong! Please pull changes manually.')
          table.insert(errors, 2, '')
          vim.notify(errors, vim.log.levels.ERROR, {
            title = 'CosmicNvim Update Failed!',
            timeout = 30000,
          })
        end
      end,
      on_stderr = function(_, err)
        table.insert(errors, err)
      end,
    })
    :sync()
end

return M
