local cosmic_modules = {
  'cosmic.compiled',
  'cosmic.disabled',
  'cosmic.pluginsInit',
  'cosmic.commands',
  'cosmic.editor',
  'cosmic.mappings',
  'cosmic.core.theme.highlights',
}

for _, mod in ipairs(cosmic_modules) do
  local ok, err = pcall(require, mod)
  if mod == 'cosmic.compiled' and not ok then
    vim.notify('Run :PackerCompile!', vim.log.levels.WARN, {
      title = 'CosmicNvim',
    })
  elseif not ok then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end

local user_config_modules = {
  'cosmic.config.editor',
  'cosmic.config.mappings',
}

for _, mod in ipairs(user_config_modules) do
  pcall(require, mod)
end
