local user_config = require('cosmic.core.user')
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'snacks'),
  ---@type snacks.Config
  opts = {
    explorer = {},
    image = {},
    input = {},
    picker = {
      formatters = {
        file = {
          filename_first = false,
          truncate = 80,
        },
      },
    },
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
  },

  keys = {
    -- notifications
    { '<leader>nh',  function() Snacks.notifier.show_history() end,                                         desc = 'Show history', },
    { '<leader>nc',  function() Snacks.notifier.hide() end,                                                 desc = 'Close notifications', },
    { '<leader>e',   function() Snacks.explorer() end,                                                      desc = 'File Explorer', },
    -- find
    { '<leader>fp',  function() Snacks.picker.files({ hidden = true, }) end,                                desc = 'Find Files', },
    { '<leader>fk',  function() Snacks.picker.buffers({ hidden = true, }) end,                              desc = 'Buffers', },
    { '<leader>fm',  function() Snacks.picker.smart({ hidden = true, }) end,                                desc = 'Smart Finder', },
    { '<leader>ff',  function() Snacks.picker.git_files({ hidden = true, }) end,                            desc = 'Find Git Files', },
    { '<leader>fr',  function() Snacks.picker.recent() end,                                                 desc = 'Recent', },
    { '<leader>ft',  function() Snacks.picker.todo_comments() end,                                          desc = 'Todo', },
    { '<leader>fT',  function() Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } }) end, desc = 'Todo/Fix/Fixme', },
    -- git
    { '<leader>go',  function() Snacks.gitbrowse() end,                                                     desc = 'Git Browse', },
    { '<leader>gl',  function() Snacks.picker.git_log() end,                                                desc = 'Git Log', },
    { "<leader>gL",  function() Snacks.picker.git_log_line() end,                                           desc = "Git Log Line" },
    { '<leader>gs',  function() Snacks.picker.git_status() end,                                             desc = 'Git Status', },
    { "<leader>gS",  function() Snacks.picker.git_stash() end,                                              desc = "Git Stash" },
    { "<leader>gb",  function() Snacks.picker.git_branches() end,                                           desc = "Git Branches" },
    { "<leader>gd",  function() Snacks.picker.git_diff() end,                                               desc = "Git Diff (Hunks)" },
    -- Grep
    { '<leader>fs',  function() Snacks.picker.grep({ hidden = true, }) end,                                 desc = 'Grep', },
    { '<leader>fl',  function() Snacks.picker.lines() end,                                                  desc = 'Buffer Lines', },
    { '<leader>fw',  function() Snacks.picker.grep_word({ hidden = true, }) end,                            desc = 'Visual selection or word', mode = { 'n', 'x' }, },
    { '<leader>fc',  function() Snacks.picker.commands() end,                                               desc = 'Commands', },
    -- search
    { '<leader>:',   function() Snacks.picker.command_history() end,                                        desc = 'Command History', },
    { '<leader>r',   function() Snacks.picker.resume() end,                                                 desc = 'Resume', },
    { '<leader>fq',  function() Snacks.picker.qflist() end,                                                 desc = 'Quickfix List', },
    -- LSP
    { '<leader>ldd', function() Snacks.picker.diagnostics() end,                                            desc = 'Project Diagnostics', },
    { '<leader>ldk', function() Snacks.picker.diagnostics_buffer() end,                                     desc = 'Buffer Diagnostics', },
    { '<leader>ly',  function() Snacks.picker.lsp_symbols() end,                                            desc = 'LSP Symbols', },
    { 'gd',          function() Snacks.picker.lsp_definitions() end,                                        desc = 'Goto Definition', },
    { "gD",          function() Snacks.picker.lsp_declarations() end,                                       desc = "Goto Declaration" },
    { 'gr',          function() Snacks.picker.lsp_references() end,                                         nowait = true,                     desc = 'References', },
    { 'gi',          function() Snacks.picker.lsp_implementations() end,                                    desc = 'Goto Implementation', },
    { 'gt',          function() Snacks.picker.lsp_type_definitions() end,                                   desc = 'Goto Type Definition', },
  },
}
