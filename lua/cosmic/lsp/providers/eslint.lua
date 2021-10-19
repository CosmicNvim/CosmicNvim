local util = require('lspconfig').util

return {
  settings = {
    packageManager = 'yarn',
    format = true,
  },
  root_dir = function(fname)
    return util.root_pattern('.git')(fname)
      or util.root_pattern('tsconfig.base.json')(fname)
      or util.root_pattern('package.json')(fname)
      or util.root_pattern('.eslintrc.js')(fname)
      or util.root_pattern('tsconfig.json')(fname)
  end,
}
