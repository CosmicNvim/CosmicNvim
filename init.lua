if not vim.fn.has('nvim-0.6') then
  error('Need NVIM 0.6 in order to run Cosmic!!')
end

local ok, err = pcall(require, 'cosmic')

if not ok then
  error(('Error loading core...\n\n%s'):format(err))
end
