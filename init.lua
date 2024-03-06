-- if vim.fn.has('nvim-0.10') == 0 then
--   error('Need Neovim v0.10+ (Nightly) in order to run Cosmic!')
-- end

local ok, err = pcall(require, 'cosmic')

if not ok then
  error(('Error loading core...\n\n%s'):format(err))
end
