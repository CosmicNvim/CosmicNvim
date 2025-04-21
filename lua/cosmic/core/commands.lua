vim.api.nvim_create_autocmd('VimResized', {
  command = 'tabdo wincmd =',
  group = vim.api.nvim_create_augroup('cosmic_resized', { clear = true }),
  desc = 'Automatically resize windows when adding/removing window'
})

vim.cmd([[
  command! CosmicUpdate lua require('cosmic.utils.cosmic').update()
  command! CosmicToggleFormatOnSave lua require('cosmic.utils.lsp').toggle_format_on_save()
]])
