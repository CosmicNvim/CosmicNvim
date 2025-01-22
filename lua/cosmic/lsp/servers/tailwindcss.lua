return {
  root_dir = function(fname)
    return require('lspconfig').util.root_pattern('tailwind.config.cjs', 'tailwind.config.js', 'tailwind.config.ts')(
      fname
    )
  end,
}
