local user_config = require('cosmic.core.user')
local icons = require('cosmic.utils.icons')
local g = vim.g

return {
  'glepnir/dashboard-nvim',
  config = function()
    g.dashboard_default_executive = 'telescope'

    g.dashboard_session_directory = vim.fn.stdpath('data') .. '/sessions'

    g.dashboard_custom_section = {
      find_file = {
        description = { icons.file1 .. ' Find File           <leader>ff' },
        command = 'lua require("cosmic.plugins.telescope.mappings").project_files()',
      },
      file_explorer = {
        description = { icons.file2 .. ' File Manager        <C-n>     ' },
        command = 'NvimTreeToggle',
      },
      find_string = {
        description = { icons.word .. ' Grep String         <leader>fs' },
        command = 'Telescope grep_string',
      },
      last_session = {
        description = { icons.clock .. ' Load Session        <leader>sl' },
        command = 'lua vim.cmd(":silent RestoreSession")',
      },
    }

    g.dashboard_custom_footer = { '💫 github.com/CosmicNvim/CosmicNvim' }

    require('dashboard').setup({
      -- config
      config = {
        header = {
          '',
          '',
          '',
          '',
          '',
          '',
          ' ██████╗ ██████╗ ███████╗███╗   ███╗██╗ ██████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗',
          '██╔════╝██╔═══██╗██╔════╝████╗ ████║██║██╔════╝████╗  ██║██║   ██║██║████╗ ████║',
          '██║     ██║   ██║███████╗██╔████╔██║██║██║     ██╔██╗ ██║██║   ██║██║██╔████╔██║',
          '██║     ██║   ██║╚════██║██║╚██╔╝██║██║██║     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
          '╚██████╗╚██████╔╝███████║██║ ╚═╝ ██║██║╚██████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
          ' ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
          '',
          '',
          '',
        },
        footer = { '💫 github.com/CosmicNvim/CosmicNvim' },
      },
    })
  end,
  event = 'VimEnter',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'dashboard'),
}
