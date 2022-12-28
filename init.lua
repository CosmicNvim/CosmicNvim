if vim.fn.has('nvim-0.8') == 0 then
  error('Need Neovim v0.8+ in order to run Cosmic!')
end

local ok, err = pcall(require, 'cosmic')

if not ok then
  error(('Error loading core...\n\n%s'):format(err))
end
