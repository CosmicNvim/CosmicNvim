local cosmic_modules = {
  'cosmic.disabled',
  'cosmic.pluginsInit',
  'cosmic.compiled',
  'cosmic.editor',
  'cosmic.core.theme.highlights',
  'cosmic.config.editor',
  'cosmic.mappings',
  'cosmic.config.mappings',
}

for _, mod in ipairs(cosmic_modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end
