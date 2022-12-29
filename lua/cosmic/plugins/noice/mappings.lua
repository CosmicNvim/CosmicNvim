local map = require('cosmic.utils').map

map('n', '<c-k>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-k>'
  end
end)

map('n', '<c-j>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-j>'
  end
end)
