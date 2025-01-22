local map = require('cosmic.utils').set_keymap

-- session
map('n', '<leader>sl', '<cmd>silent RestoreSession<cr>', { desc = 'Restore session' })
map('n', '<leader>ss', '<cmd>SaveSession<cr>', { desc = 'Save session' })
