local user_config = require('cosmic.core.user')

-- set up diagnostics
vim.diagnostic.config(user_config.diagnostics)
