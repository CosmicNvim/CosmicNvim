local modules = require('cosmic.utils.modules')

local cosmic_modules = {
  'cosmic.core.editor',
  'cosmic.core.pluginsInit',
  'cosmic.core.commands',
  'cosmic.lsp',
  'cosmic.config.editor',
  -- load mappings only after editor configs are loaded
  'cosmic.core.mappings',
}

-- set up lazy.nvim to install plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local function bootstrap_error(reason)
  error(
    (
      '[CosmicNvim] Cannot bootstrap lazy.nvim at %s:\n%s\nInstall Git/check network access, then restart Neovim. '
      .. 'If the destination is incomplete, remove only that directory before retrying.'
    ):format(lazypath, reason),
    0
  )
end

if not vim.uv.fs_stat(lazypath) then
  if vim.fn.executable('git') ~= 1 then
    bootstrap_error('Git executable not found in PATH.')
  end
  local ok, output = pcall(vim.fn.system, {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
  if not ok or vim.v.shell_error ~= 0 then
    bootstrap_error(('git clone failed: %s'):format(tostring(output)))
  end
end
if not vim.uv.fs_stat(lazypath .. '/lua/lazy/init.lua') then
  bootstrap_error('The destination does not contain lua/lazy/init.lua; the installation may be incomplete.')
end
vim.opt.runtimepath:prepend(lazypath)

-- set up cosmicnvim
for _, mod in ipairs(cosmic_modules) do
  if mod:find('^cosmic%.config%.') then
    modules.optional_require(mod)
  else
    local ok, err = pcall(require, mod)
    if not ok then
      error(('Error loading %s...\n\n%s'):format(mod, err))
    end
  end
end
