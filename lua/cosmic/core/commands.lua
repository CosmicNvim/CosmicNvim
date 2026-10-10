vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    -- :tabdo would leave the last tab page current; win_execute equalizes each tab page in place
    for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
      vim.fn.win_execute(vim.api.nvim_tabpage_get_win(tabpage), 'wincmd =')
    end
  end,
  group = vim.api.nvim_create_augroup('cosmic_resized', { clear = true }),
  desc = 'Automatically resize windows when adding/removing window',
})

vim.api.nvim_create_user_command('CosmicUpdate', function()
  require('cosmic.utils.cosmic').update()
end, { desc = 'Update CosmicNvim and optionally restore plugins to its lockfile' })
