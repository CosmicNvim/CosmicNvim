return {
  'numToStr/Comment.nvim',
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      opts = {
        enable_autocmd = false,
        languages = {
          javascript = {
            __default = '// %s',
            __multiline = '/* %s */',
            jsx_element = '{/* %s */}',
            jsx_fragment = '{/* %s */}',
            jsx_self_closing_element = {
              __default = '{/* %s */}',
              __multiline = '{/* %s */}',
            },
          },
          tsx = {
            __default = '// %s',
            __multiline = '/* %s */',
            jsx_element = '{/* %s */}',
            jsx_fragment = '{/* %s */}',
            jsx_self_closing_element = {
              __default = '{/* %s */}',
              __multiline = '{/* %s */}',
            },
          },
        },
      },
    },
  },
  opts = function()
    local comment_utils = require('Comment.utils')
    local ts_context_commentstring = require('ts_context_commentstring')

    local function get_line_start_location(line)
      local first_non_whitespace_col = vim.fn.match(vim.fn.getline(line + 1), '\\S')

      return {
        line,
        math.max(first_non_whitespace_col, 0),
      }
    end

    local function get_comment_location(ctx)
      if
        ctx.cmotion == comment_utils.cmotion.block
        or ctx.cmotion == comment_utils.cmotion.v
        or ctx.cmotion == comment_utils.cmotion.V
      then
        return get_line_start_location(vim.fn.getpos("'<")[2] - 1)
      end

      return get_line_start_location(vim.api.nvim_win_get_cursor(0)[1] - 1)
    end

    local function find_jsx_ancestor(node)
      while node do
        local node_type = node:type()

        if node_type == 'jsx_element' or node_type == 'jsx_fragment' or node_type == 'jsx_self_closing_element' then
          return node
        end

        node = node:parent()
      end
    end

    return {
      pre_hook = function(ctx)
        local key = ctx.ctype == comment_utils.ctype.linewise and '__default' or '__multiline'
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        local location = get_comment_location(ctx)

        if ok then
          parser:parse(true)

          local node = parser:named_node_for_range({
            location[1],
            location[2],
            location[1],
            location[2],
          })

          if find_jsx_ancestor(node) then
            return '{/* %s */}'
          end
        end

        return ts_context_commentstring.calculate_commentstring({
          key = key,
          location = location,
        })
      end,
    }
  end,
  lazy = false,
}
