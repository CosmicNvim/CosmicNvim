local diagnostic = {}
local hover = {}
local signature_help = {}
local user_config = require('cosmic.config')
local icons = require('cosmic.theme.icons')

if user_config and user_config.lsp and user_config.lsp.diagnostic then
  diagnostic = user_config.lsp.diagnostic
end
if user_config and user_config.lsp and user_config.lsp.hover then
  hover = user_config.lsp.hover
end
if user_config and user_config.lsp and user_config.lsp.signature_help then
  signature_help = user_config.lsp.signature_help
end

require('cosmic-ui').setup({
  border = 'rounded',
  icons = icons,
  diagnostic = diagnostic,
  hover = hover,
  signature_help = signature_help,
})
