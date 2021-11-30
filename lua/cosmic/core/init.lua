local cosmic_modules = {
  'cosmic.core.disabled',
  'cosmic.core.pluginsInit',
  'cosmic.core.commands',
  'cosmic.core.editor',
  'cosmic.config.editor',
  'cosmic.core.mappings',
  'cosmic.config.mappings',
}

for _, mod in ipairs(cosmic_modules) do
  local ok, err = pcall(require, mod)
  if not ok and not mod:find('cosmic.config') then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end
