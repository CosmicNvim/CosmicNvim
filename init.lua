if vim.fn.has('nvim-0.6') == 0 then
  error('Need NVIM 0.6 in order to run Cosmic!!')
end

do
  local ok, _ = pcall(require, 'impatient')

  if not ok then
    vim.notify('impatient.nvim not installed', vim.log.levels.WARN)
  end
end

local ok, err = pcall(require, 'cosmic')

if not ok then
  error(('Error loading core...\n\n%s'):format(err))
end
