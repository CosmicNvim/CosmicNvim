require('cosmic.disabled')
require('cosmic.pluginsInit')
require('cosmic.compiled')
require('cosmic.mappings')
require('cosmic.editor')

do
  local ok, err = pcall(require, 'cosmic.config.editor')
  if not ok then
    error(string.format('Error loading custor editor settings...\n\n%s', err))
  end
end
