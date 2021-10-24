local ok, err = pcall(require, 'cosmic')

if not ok then
  error(string.format('Error loading core...\n\n%s', err))
end
