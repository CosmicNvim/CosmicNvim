vim.cmd([[
  command! CosmicUpdate lua require('cosmic.utils').update()
  command! CosmicReload lua require('cosmic.utils').reload_user_config(true)
  command! CosmicReloadSync lua require('cosmic.utils').reload_user_config_sync()
  command! LspFormat lua vim.lsp.buf.formatting()

  augroup Cosmic_Auto_Resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
]])
