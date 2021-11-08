vim.cmd([[
command! CosmicUpdate lua require('cosmic.utils').update()
command! CosmicReloadConfig lua require('cosmic.utils').reload_user_config()
command! CosmicReload lua require('cosmic.utils').reload_cosmic()
]])
