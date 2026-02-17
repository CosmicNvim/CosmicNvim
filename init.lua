if vim.fn.has('nvim-0.11') == 0 then
  error('Need Neovim v0.11+ (Nightly) in order to run Cosmic!')
end

if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

local ok, err = pcall(require, 'cosmic')

if not ok then
  error(('Error loading core...\n\n%s'):format(err))
end
