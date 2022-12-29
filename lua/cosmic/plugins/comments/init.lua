local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup(u.merge({
      pre_hook = function(ctx)
        local U = require('Comment.utils')
        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring({
          key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
          location = location,
        })
      end,
    }, user_config.plugins.comment_nvim or {}))
  end,
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'comment-nvim'),
}
