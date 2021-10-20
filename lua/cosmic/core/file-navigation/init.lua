local actions = require('telescope.actions')
local mappings = require('cosmic.core.file-navigation.mappings').mappings()
local icons = require('cosmic.core.theme.icons')

require('telescope').setup({
  defaults = {
    prompt_prefix = '🔍 ',
    selection_caret = icons.folder.arrow_closed,
    file_ignore_patterns = {
      '.git/',
    },
    vimgrep_arguments = {
      'rg',
      '--ignore',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
  pickers = {
    buffers = {
      prompt_title = '✨ Search Buffers ✨',
      mappings = {
        n = {
          ['d'] = actions.delete_buffer,
        },
      },
      sort_mru = true,
      preview_title = false,
    },
    lsp_references = {
      initial_mode = 'normal',
      sorting_strategy = 'ascending',
      layout_strategy = 'cursor',
      preview_title = false,
      results_title = false,
      prompt_title = 'References',
      layout_config = {
        width = 0.4,
        height = 0.4,
      },
    },
    lsp_code_actions = {
      initial_mode = 'normal',
      sorting_strategy = 'ascending',
      layout_strategy = 'cursor',
      preview = false,
      prompt_title = 'Code Actions',
      results_title = '',
      layout_config = {
        width = 0.2,
        height = 0.3,
      },
    },
    lsp_range_code_actions = {
      initial_mode = 'normal',
      sorting_strategy = 'ascending',
      layout_strategy = 'cursor',
      preview = false,
      prompt_title = 'Code Actions',
      results_title = '',
      layout_config = {
        width = 0.3,
        height = 0.3,
      },
    },
    lsp_document_diagnostics = {
      initial_mode = 'normal',
      sorting_strategy = 'ascending',
      layout_strategy = 'cursor',
      prompt_title = 'Diagnostics',
      results_title = '',
      layout_config = {
        width = 0.5,
        height = 0.5,
      },
      mappings = mappings,
    },
    lsp_definitions = {
      layout_strategy = 'cursor',
      prompt_title = 'Definitions',
      preview_title = false,
      results_title = false,
      layout_config = {
        width = 0.5,
        height = 0.5,
      },
      mappings = mappings,
    },
    find_files = {
      prompt_title = '✨ Search Project ✨',
      mappings = mappings,
      hidden = true,
    },
    git_files = {
      prompt_title = '✨ Search Git Project ✨',
      mappings = mappings,
      hidden = true,
    },
    live_grep = {
      prompt_title = '✨ Live Grep ✨',
      mappings = mappings,
    },
  },
})

require('telescope').load_extension('fzf')
