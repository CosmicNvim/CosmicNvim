vim.keymap.set('n', '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, {
  silent = true,
  expr = true,
})

vim.keymap.set('n', '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, {
  silent = true,
  expr = true,
})
