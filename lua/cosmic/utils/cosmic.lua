local M = {}

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
        vim.notify('Updating...')
      end,
      on_exit = function()
        if vim.tbl_isempty(errors) then
          vim.notify('Updated! Running CosmicReloadSync...')
          M.reload_user_config_sync()
        else
          table.insert(errors, 1, 'Something went wrong! Please pull changes manually.')
          table.insert(errors, 2, '')
          vim.notify('Update failed!', vim.log.levels.ERROR)
        end
      end,
      on_stderr = function(_, err)
        table.insert(errors, err)
      end,
    })
    :sync()
end

return M
