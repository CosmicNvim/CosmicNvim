require('cosmic.disabled')
require('cosmic.pluginsInit')
require('cosmic.compiled')
require('cosmic.editor')
require('cosmic.mappings')

do
  local ok, err = pcall(require, 'cosmic.config.editor')
  if not ok then
    error(string.format('Error loading custom editor settings...\n\n%s', err))
  end
end

do
  local ok, err = pcall(require, 'cosmic.config.mappings')
  if not ok then
    error(string.format('Error loading custom mapping settings...\n\n%s', err))
  end
end
