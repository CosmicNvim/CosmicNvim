local user_config = require('cosmic.core.user')
return {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup({
      check_ts = true,
      ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        java = false,
      },
      disable_filetype = { 'TelescopePrompt', 'vim' },
      fast_wrap = {},
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'autopairs'),
}
