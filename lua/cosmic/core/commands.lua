local augroup_name = 'CosmicNvim'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local map = require('cosmic.utils').set_keymap
local lsp_utils = require('cosmic.utils.lsp')

vim.api.nvim_create_autocmd('VimResized', {
  command = 'tabdo wincmd =',
  group = group,
})

vim.cmd([[
  command! CosmicUpdate lua require('cosmic.utils.cosmic').update()
  command! CosmicDisableFormatOnSave lua require('cosmic.utils.lsp').toggle_format_on_save()
]])

map('n', '<leader>lx', lsp_utils.toggle_format_on_save, { desc = 'Toggle format on save' })
