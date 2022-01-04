local galaxy = require('galaxyline')
local gls = galaxy.section
local diag = require('galaxyline.providers.diagnostic')
local condition = require('galaxyline.condition')
local fileinfo = require('galaxyline.providers.fileinfo')
local utils = require('cosmic.utils')
local colors = require('cosmic.theme.colors')
local set_highlight = require('cosmic.theme.utils').set_highlight
local icons = require('cosmic.theme.icons')
local config = require('cosmic.config')
local get_highlight = require('cosmic.theme.utils').get_highlight
local statusline_colors = get_highlight('StatusLine')

local defaults = utils.merge({
  main_icon = icons.cosmic,
}, config.statusline or {})
local main_icon = defaults.main_icon

local get_mode = function()
  local mode_colors = {
    [110] = { 'NORMAL', colors.normal, colors.bg_highlight },
    [105] = { 'INSERT', colors.insert, colors.bg_highlight },
    [99] = { 'COMMAND', colors.command, colors.bg_highlight },
    [116] = { 'TERMINAL', colors.normal, colors.bg_highlight },
    [118] = { 'VISUAL', colors.visual, colors.bg_highlight },
    [22] = { 'V-BLOCK', colors.visual, colors.bg_highlight },
    [86] = { 'V-LINE', colors.visual, colors.bg_highlight },
    [82] = { 'REPLACE', colors.replace, colors.bg_highlight },
    [115] = { 'SELECT', colors.replace, colors.bg_highlight },
    [83] = { 'S-LINE', colors.replace, colors.bg_highlight },
  }

  local mode_data = mode_colors[vim.fn.mode():byte()]
  if mode_data ~= nil then
    return mode_data
  end
end

local function get_basename(file)
  return file:match('^.+/(.+)$')
end

local function get_git_root()
  local git_dir = require('galaxyline.providers.vcs').get_git_dir()
  if not git_dir then
    return 'not a git dir '
  end

  local git_root = git_dir:gsub('/.git/?$', '')
  return get_basename(git_root) .. ' '
end

local check_git_and_buffer = function()
  return condition.check_git_workspace() and condition.buffer_not_empty()
end

local check_buffer_and_width = function()
  return condition.buffer_not_empty() and condition.hide_in_width()
end

local FilePathShortProvider = function()
  local fp = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
  local tbl = utils.split(fp, '/')
  local len = #tbl

  if len > 2 and tbl[1] ~= '~' then
    return icons.dotdotdot .. '/' .. table.concat(tbl, '/', len - 1) .. '/'
  else
    return fp .. '/'
  end
end

local LineColumnProvider = function()
  local line_column = fileinfo.line_column()
  line_column = line_column:gsub('%s+', '')
  return ' ' .. icons.line_number .. line_column
end

local PercentProvider = function()
  local line_column = fileinfo.current_line_percent()
  line_column = line_column:gsub('%s+', '')
  return line_column .. ' ☰'
end

local BracketProvider = function(icon, cond)
  return function()
    local result

    if type(cond) == 'boolean' then
      result = cond
    else
      result = cond()
    end

    if result == nil then
      return
    end

    if type(result) == 'number' then
      if result > 0 then
        return icon
      end
    end

    if type(result) == 'boolean' and result == true then
      return icon
    end

    if type(result) == 'string' then
      if #result > 0 then
        return icon
      end
    end
  end
end

galaxy.short_line_list = {
  'packer',
  'NvimTree',
  'floaterm',
  'fugitive',
  'fugitiveblame',
}

gls.left = {
  {
    GhostLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, true),
      highlight = 'GalaxyViModeNestedInv',
    },
  },
  {
    Ghost = {
      provider = BracketProvider(main_icon, true),
      highlight = 'GalaxyViModeInv',
    },
  },
  {
    ViModeLeftBracket = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      highlight = 'GalaxyViMode',
    },
  },
  {
    ViMode = {
      provider = function()
        local m = get_mode()
        if m == nil then
          return
        end

        local label, mode_color, mode_nested = unpack(m)
        set_highlight('GalaxyViMode', {
          guibg = mode_color,
          guifg = mode_nested,
        })
        set_highlight('GalaxyViModeInv', {
          guibg = mode_nested,
          guifg = mode_color,
        })
        set_highlight('GalaxyViModeNested', {
          guibg = mode_nested,
          guifg = 'StatusLine',
        })
        set_highlight('GalaxyViModeNestedInv', {
          guibg = 'StatusLine',
          guifg = mode_nested,
        })
        set_highlight('GalaxyPercentBracket', {
          guibg = 'StatusLine',
          guifg = mode_color,
        })
        set_highlight('GalaxyGitLCBracket', {
          guibg = mode_nested,
          guifg = mode_color,
        })

        if condition.buffer_not_empty() then
          set_highlight('GalaxyViModeBracket', {
            guibg = mode_nested,
            guifg = mode_color,
          })
        else
          if condition.check_git_workspace() then
            set_highlight('GalaxyGitLCBracket', {
              guibg = 'StatusLine',
              guifg = mode_color,
            })
          end
          set_highlight('GalaxyViModeBracket', {
            guibg = 'StatusLine',
            guifg = mode_color,
          })
        end
        return '  ' .. label .. ' '
      end,
    },
  },
  {
    ViModeBracket = {
      provider = BracketProvider(icons.arrow_right_filled, true),
      highlight = 'GalaxyViModeBracket',
    },
  },
  {
    GitIcon = {
      provider = BracketProvider('  ' .. icons.branch .. ' ', true),
      condition = check_git_and_buffer,
      highlight = 'GalaxyViModeInv',
    },
  },
  {
    GitBranch = {
      provider = function()
        local vcs = require('galaxyline.providers.vcs')
        local branch_name = vcs.get_git_branch()
        if not branch_name then
          return ' no git '
        end
        if string.len(branch_name) > 28 then
          return string.sub(branch_name, 1, 25) .. icons.dotdotdot
        end
        return branch_name .. ' '
      end,
      condition = check_git_and_buffer,
      highlight = 'GalaxyViModeInv',
      separator = icons.arrow_right,
      separator_highlight = 'GalaxyViModeInv',
    },
  },
  {
    FileIcon = {
      provider = function()
        local icon = fileinfo.get_file_icon()
        if condition.check_git_workspace() then
          return ' ' .. icon
        end

        return '  ' .. icon
      end,
      condition = condition.buffer_not_empty,
      highlight = 'GalaxyViModeInv',
    },
  },
  {
    FilePath = {
      provider = FilePathShortProvider,
      condition = check_buffer_and_width,
      highlight = 'GalaxyViModeInv',
    },
  },
  {
    FileName = {
      provider = 'FileName',
      condition = condition.buffer_not_empty,
      highlight = 'GalaxyViModeInv',
      separator = icons.arrow_right_filled,
      separator_highlight = 'GalaxyViModeNestedInv',
    },
  },
  {
    DiffAdd = {
      provider = 'DiffAdd',
      icon = ' ' .. icons.diff_add,
      condition = check_git_and_buffer,
      highlight = { colors.diffAdd, 'StatusLine' },
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = check_git_and_buffer,
      icon = ' ' .. icons.diff_modified,
      highlight = { colors.diffModified, 'StatusLine' },
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = check_git_and_buffer,
      icon = ' ' .. icons.diff_remove,
      highlight = { colors.diffDeleted, 'StatusLine' },
    },
  },
}

gls.right = {
  -- Error
  {
    DiagnosticErrorLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_error),
      highlight = 'DiagnosticError',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticError = {
      provider = diag.get_diagnostic_error,
      highlight = 'DiagnosticErrorInv',
      icon = '  ' .. icons.error .. ' ',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticErrorRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled .. ' ', diag.get_diagnostic_error),
      highlight = 'DiagnosticError',
      condition = condition.buffer_not_empty,
    },
  },
  -- Warning
  {
    DiagnosticWarnLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_warn),
      highlight = 'DiagnosticWarn',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticWarn = {
      provider = diag.get_diagnostic_warn,
      highlight = 'DiagnosticWarnInv',
      icon = '  ' .. icons.warn .. ' ',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticWarnRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled .. ' ', diag.get_diagnostic_warn),
      highlight = 'DiagnosticWarn',
      condition = condition.buffer_not_empty,
    },
  },
  -- Hint
  {
    DiagnosticHintLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_hint),
      highlight = 'DiagnosticHint',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticHint = {
      provider = diag.get_diagnostic_hint,
      icon = '  ' .. icons.hint .. ' ',
      highlight = 'DiagnosticHintInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticHintRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled .. ' ', diag.get_diagnostic_hint),
      highlight = 'DiagnosticHint',
      condition = condition.buffer_not_empty,
    },
  },
  -- Git
  {
    GitBranchRightBracket = {
      provider = BracketProvider(icons.arrow_left_filled, true),
      condition = check_buffer_and_width,
      highlight = 'GalaxyViModeNestedInv',
    },
  },
  {
    LSPStatus = {
      provider = function()
        local clients = utils.get_active_lsp_client_names()
        local client_str = ''

        if #clients < 1 then
          return client_str
        end

        for i, client in ipairs(clients) do
          client_str = client_str .. client
          if i < #clients then
            client_str = client_str .. ', '
          end
        end

        if client_str:len() < 1 then
          return
        end

        return '  (' .. client_str .. ')'
      end,
      highlight = 'GalaxyViModeInv',
      condition = check_buffer_and_width,
    },
  },
  {
    LSPStatusArrow = {
      provider = BracketProvider('  ' .. icons.arrow_left, true),
      highlight = 'GalaxyViModeInv',
      condition = check_buffer_and_width,
    },
  },
  {
    GitRoot = {
      provider = get_git_root,
      condition = check_buffer_and_width,
      icon = '  ' .. icons.file .. ' ',
      highlight = 'GalaxyViModeInv',
    },
  },
  -- Editor info
  {
    LineColumn = {
      provider = {
        LineColumnProvider,
        function()
          return ' '
        end,
      },
      highlight = 'GalaxyViMode',
      separator = icons.arrow_left_filled,
      separator_highlight = 'GalaxyGitLCBracket',
    },
  },
  {
    PerCent = {
      provider = {
        PercentProvider,
      },
      highlight = 'GalaxyViMode',
      separator = icons.arrow_left .. ' ',
      separator_highlight = 'GalaxyViModeLeftBracket',
    },
  },
  {
    PercentRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      highlight = 'GalaxyPercentBracket',
    },
  },
}

gls.short_line_left = {
  {
    GhostLeftBracketShort = {
      provider = BracketProvider(icons.rounded_left_filled, true),
      highlight = { colors.white, 'StatusLine' },
    },
  },
  {
    GhostShort = {
      provider = BracketProvider(main_icon, true),
      highlight = { 'StatusLine', colors.white },
    },
  },
  {
    GhostRightBracketShort = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      highlight = { colors.white, 'StatusLine' },
    },
  },
  {
    FileIconShort = {
      provider = {
        function()
          return '  '
        end,
        'FileIcon',
      },
      condition = function()
        return condition.buffer_not_empty() and vim.bo.filetype ~= 'NvimTree'
      end,
      highlight = {
        require('galaxyline.providers.fileinfo').get_file_icon,
        'StatusLine',
      },
    },
  },
  {
    FilePathShort = {
      provider = FilePathShortProvider,
      condition = function()
        return condition.buffer_not_empty() and vim.bo.filetype ~= 'NvimTree'
      end,
      highlight = { colors.white, 'StatusLine' },
    },
  },
  {
    FileNameShort = {
      provider = 'FileName',
      condition = function()
        return condition.buffer_not_empty() and vim.bo.filetype ~= 'NvimTree'
      end,
      highlight = { colors.white, 'StatusLine' },
    },
  },
}

gls.short_line_right = {
  {
    GitRootShortLeftBracket = {
      provider = BracketProvider(icons.arrow_left_filled, true),
      condition = condition.buffer_not_empty,
      highlight = { colors.white, 'StatusLine' },
    },
  },
  {
    GitRootShort = {
      provider = get_git_root,
      condition = condition.buffer_not_empty,
      icon = '  ' .. icons.file .. ' ',
      highlight = { statusline_colors.guibg, colors.white },
    },
  },
  {
    GitRootShortRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      condition = condition.buffer_not_empty,
      highlight = { colors.white, 'StatusLine' },
    },
  },
}
