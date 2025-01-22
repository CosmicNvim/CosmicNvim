local user_config = require('cosmic.core.user')
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'snacks'),
  ---@type snacks.Config
  opts = {
    picker = {
      ---@class snacks.picker.formatters.Config
      formatters = {
        file = {
          filename_first = false, -- display filename before the file path
        },
      },
    },
    ---@class snacks.notifier.Config
    ---@field enabled? boolean
    ---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
    ---@field filter? fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
    notifier = {
      filter = function(notif)
        local banned_msgs = { 'No information available' }
        for _, banned_msg in ipairs(banned_msgs) do
          if banned_msg == notif.msg then
            return false
          end
        end
        return true
      end,
    },
    gitbrowse = {},
    indent = {},
    --[[ dashboard = require('cosmic.plugins.snacks.dashboard'), ]]
  },

  keys = {
    -- notifications
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Show history',
    },
    {
      '<leader>nc',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Close notifications',
    },
    -- find
    {
      '<leader>fp',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fk',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    {
      '<leader>ft',
      function()
        Snacks.picker.todo_comments()
      end,
      desc = 'Todo',
    },
    {
      '<leader>fT',
      function()
        Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } })
      end,
      desc = 'Todo/Fix/Fixme',
    },
    -- git
    {
      '<leader>go',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    -- Grep
    {
      '<leader>fs',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word({
          hidden = true,
        })
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    -- search
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>r',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>fq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    -- LSP
    {
      '<leader>fy',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gi',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gt',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto Type Definition',
    },
  },
}
