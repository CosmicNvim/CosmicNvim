local cosmic_modules = {
  'cosmic.compiled',
  'cosmic.core.disabled',
  'cosmic.pluginsInit',
  'cosmic.core.commands',
  'cosmic.core.editor',
  'cosmic.config.editor',
  'cosmic.core.mappings',
  'cosmic.config.mappings',
  'cosmic.theme.highlights',
}

for _, mod in ipairs(cosmic_modules) do
  local ok, err = pcall(require, mod)
  if mod == 'cosmic.compiled' and not ok then
    vim.notify('Run :PackerCompile!', vim.log.levels.WARN, {
      title = 'CosmicNvim',
    })
  elseif not ok and not mod:find('cosmic.config') then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end
