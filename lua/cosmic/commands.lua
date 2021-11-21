vim.cmd([[
command! CosmicUpdate lua require('cosmic.utils').update()
command! CosmicReload lua require('cosmic.utils').reload_user_config(true)
command! CosmicReloadSync lua require('cosmic.utils').reload_user_config_sync()
]])
