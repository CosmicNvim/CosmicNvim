return {
  'tpope/vim-fugitive',
  -- fugitive defines :Gdiffsplit, :Gwrite, :GBrowse and more when it loads, not just :Git
  event = 'VeryLazy',
  cmd = 'Git',
}
