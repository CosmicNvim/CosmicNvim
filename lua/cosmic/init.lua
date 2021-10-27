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
    error(string.format('Error loading %s...\n\n%s', mod, err))
  end
end
