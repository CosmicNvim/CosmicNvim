local actions = require('telescope.actions')
local mappings = require('cosmic.core.navigation.mappings').mappings()
local icons = require('cosmic.core.theme.icons')

local opts_cursor = {
  initial_mode = 'normal',
  sorting_strategy = 'ascending',
  layout_strategy = 'cursor',
  results_title = false,
  layout_config = {
    width = 0.5,
    height = 0.4,
  },
}

local opts_vertical = {
  initial_mode = 'normal',
  sorting_strategy = 'ascending',
  layout_strategy = 'vertical',
  results_title = false,
  layout_config = {
    width = 0.3,
    height = 0.5,
    prompt_position = 'top',
    mirror = true,
  },
}

require('telescope').setup({
  defaults = {
    prompt_prefix = '🔍 ',
    selection_caret = icons.folder.arrow_closed,
    file_ignore_patterns = {
      '.git/',
    },
    dynamic_preview_title = true,
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
      mappings = vim.tbl_deep_extend('force', {
        n = {
          ['d'] = actions.delete_buffer,
        },
      }, mappings),
      sort_mru = true,
      preview_title = false,
    },
    lsp_code_actions = vim.tbl_deep_extend('force', opts_cursor, {
      prompt_title = 'Code Actions',
    }),
    lsp_range_code_actions = vim.tbl_deep_extend('force', opts_vertical, {
      prompt_title = 'Code Actions',
    }),
    lsp_document_diagnostics = vim.tbl_deep_extend('force', opts_vertical, {
      prompt_title = 'Document Diagnostics',
      mappings = mappings,
    }),
    lsp_implementations = vim.tbl_deep_extend('force', opts_cursor, {
      prompt_title = 'Implementations',
      mappings = mappings,
    }),
    lsp_definitions = vim.tbl_deep_extend('force', opts_cursor, {
      prompt_title = 'Definitions',
      mappings = mappings,
    }),
    lsp_references = vim.tbl_deep_extend('force', opts_cursor, {
      prompt_title = 'References',
      mappings = mappings,
    }),
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
