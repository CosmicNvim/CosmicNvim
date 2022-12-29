local mods = {
  'cosmic.core',
}

for _, mod in ipairs(mods) do
  local ok, err = pcall(require, mod)
  if not ok and not mod:find('cosmic.core.user') then
    error(('Error loading %s...\n\n%s'):format(mod, err))
  end
end
