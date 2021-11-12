vim.cmd([[
command! CosmicUpdate lua require('cosmic.utils').update()
command! CosmicReload lua require('cosmic.utils').reload_cosmic()
]])
-- command! CosmicReloadSync lua require('cosmic.utils').reload_cosmic(true)
