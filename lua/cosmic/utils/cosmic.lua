local M = {}

function M.get_install_dir()
  local config_dir = os.getenv('COSMICNVIM_INSTALL_DIR')
  if not config_dir then
    return vim.fn.stdpath('config')
  end
  return config_dir
end

-- Update CosmicNvim without blocking the editor or reloading live configuration.
function M.update()
  local path = M.get_install_dir()
  vim.notify('Updating CosmicNvim...')

  local ok, err = pcall(
    vim.system,
    { 'git', 'pull', '--ff-only' },
    { cwd = path, text = true },
    vim.schedule_wrap(function(result)
      if result.code == 0 then
        vim.notify('CosmicNvim updated. Restart Neovim to load the changes.')
        return
      end

      local details = vim.trim(result.stderr or '')
      if details == '' then
        details = vim.trim(result.stdout or '')
      end
      local message = ('CosmicNvim update failed in %s (exit code %s).'):format(path, result.code)
      if details ~= '' then
        message = message .. '\n' .. details
      end
      vim.notify(message, vim.log.levels.ERROR)
    end)
  )
  if not ok then
    vim.notify(('Could not start CosmicNvim update in %s:\n%s'):format(path, err), vim.log.levels.ERROR)
  end
end

return M
