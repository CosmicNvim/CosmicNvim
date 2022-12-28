local map = require('cosmic.utils').map

map('n', '<c-d>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-d>'
  end
end)

map('n', '<c-u>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-u>'
  end
end)
