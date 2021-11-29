local cosmic_modules = {
  'cosmic.compiled',
  'cosmic.disabled',
  'cosmic.pluginsInit',
  'cosmic.commands',
  'cosmic.editor',
  'cosmic.config.editor',
  'cosmic.mappings',
  'cosmic.config.mappings',
  'cosmic.core.theme.highlights',
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
