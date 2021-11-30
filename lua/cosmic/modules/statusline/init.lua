local galaxy = require('galaxyline')
local gls = galaxy.section
local diag = require('galaxyline.providers.diagnostic')
local condition = require('galaxyline.condition')
local fileinfo = require('galaxyline.providers.fileinfo')
local utils = require('cosmic.utils')
local colors = require('cosmic.theme.colors')
local highlight = utils.highlight
local icons = require('cosmic.theme.icons')
local config = require('cosmic.config')

local defaults = vim.tbl_deep_extend('force', {
  statusline = {
    main_icon = icons.cosmic,
  },
}, config.statusline or {})
local main_icon = defaults.statusline.main_icon

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

local check_width_and_git_and_buffer = function()
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

    if cond == true or cond == false then
      result = cond
    else
      result = cond()
    end

    if result ~= nil and result ~= '' then
      return icon
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

gls.mid = {
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

        return 'LSP: [' .. client_str .. ']'
      end,
      highlight = 'GalaxyText',
    },
  },
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
        highlight('GalaxyViMode', mode_color, mode_nested)
        highlight('GalaxyViModeInv', mode_nested, mode_color)
        highlight('GalaxyViModeNested', mode_nested, colors.statusline_bg)
        highlight('GalaxyViModeNestedInv', colors.statusline_bg, mode_nested)
        highlight('GalaxyPercentBracket', colors.statusline_bg, mode_color)
        highlight('GalaxyText', colors.statusline_bg, mode_color)

        highlight('GalaxyGitLCBracket', mode_nested, mode_color)

        if condition.buffer_not_empty() then
          highlight('GalaxyViModeBracket', mode_nested, mode_color)
        else
          if condition.check_git_workspace() then
            highlight('GalaxyGitLCBracket', colors.statusline_bg, mode_color)
          end
          highlight('GalaxyViModeBracket', colors.statusline_bg, mode_color)
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
      condition = check_width_and_git_and_buffer,
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
      condition = check_width_and_git_and_buffer,
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
      icon = '  ',
      condition = check_width_and_git_and_buffer,
      highlight = { colors.diffAdd, colors.statusline_bg },
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = check_width_and_git_and_buffer,
      icon = '  ',
      highlight = { colors.diffModified, colors.statusline_bg },
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = check_width_and_git_and_buffer,
      icon = '  ',
      highlight = { colors.diffDeleted, colors.statusline_bg },
    },
  },
  {
    WSpace = {
      provider = 'WhiteSpace',
      highlight = { colors.statusline_bg, colors.statusline_bg },
    },
  },
}

gls.right = {
  {
    DiagnosticErrorLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_error),
      highlight = 'GalaxyDiagnosticErrorInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticError = {
      provider = function()
        local error_result = diag.get_diagnostic_error()
        highlight('GalaxyDiagnosticError', colors.error, colors.statusline_bg)
        highlight('GalaxyDiagnosticErrorInv', colors.statusline_bg, colors.error)

        if error_result ~= '' and error_result ~= nil then
          return error_result
        end
      end,
      icon = icons.error .. ' ',
      highlight = 'GalaxyDiagnosticError',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticErrorRightBracket = {
      provider = {
        BracketProvider(icons.rounded_right_filled, diag.get_diagnostic_error),
        BracketProvider(' ', diag.get_diagnostic_error),
      },
      highlight = 'GalaxyDiagnosticErrorInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticWarnLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_warn),
      highlight = 'GalaxyDiagnosticWarnInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticWarn = {
      provider = function()
        local warn_result = diag.get_diagnostic_warn()
        highlight('GalaxyDiagnosticWarn', colors.warn, colors.statusline_bg)
        highlight('GalaxyDiagnosticWarnInv', colors.statusline_bg, colors.warn)

        if warn_result ~= '' and warn_result ~= nil then
          return warn_result
        end
      end,
      highlight = 'GalaxyDiagnosticWarn',
      icon = icons.warn .. ' ',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticWarnRightBracket = {
      provider = {
        BracketProvider(icons.rounded_right_filled, diag.get_diagnostic_warn),
        BracketProvider(' ', diag.get_diagnostic_warn),
      },
      highlight = 'GalaxyDiagnosticWarnInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    DiagnosticInfoLeftBracket = {
      provider = BracketProvider(icons.rounded_left_filled, diag.get_diagnostic_info),
      highlight = 'GalaxyDiagnosticInfoInv',
    },
  },
  {
    DiagnosticInfo = {
      provider = function()
        local info_result = diag.get_diagnostic_info()
        highlight('GalaxyDiagnosticInfo', colors.info, colors.statusline_bg)
        highlight('GalaxyDiagnosticInfoInv', colors.statusline_bg, colors.info)

        if info_result ~= '' and info_result ~= nil then
          return info_result
        end
      end,
      icon = icons.info .. ' ',
      highlight = 'GalaxyDiagnosticInfo',
      condition = check_width_and_git_and_buffer,
    },
  },
  {
    DiagnosticInfoRightBracket = {
      provider = {
        BracketProvider(icons.rounded_right_filled, diag.get_diagnostic_info),
        BracketProvider(' ', diag.get_diagnostic_info),
      },
      highlight = 'GalaxyDiagnosticInfoInv',
      condition = condition.buffer_not_empty,
    },
  },
  {
    GitBranchRightBracket = {
      provider = BracketProvider(icons.arrow_left_filled, true),
      condition = check_buffer_and_width,
      highlight = 'GalaxyViModeNestedInv',
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
      highlight = { colors.white, colors.statusline_bg },
    },
  },
  {
    GhostShort = {
      provider = BracketProvider(main_icon, true),
      highlight = { colors.statusline_bg, colors.white },
    },
  },
  {
    GhostRightBracketShort = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      highlight = { colors.white, colors.statusline_bg },
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
        colors.statusline_bg,
      },
    },
  },
  {
    FilePathShort = {
      provider = FilePathShortProvider,
      condition = function()
        return condition.buffer_not_empty() and vim.bo.filetype ~= 'NvimTree'
      end,
      highlight = { colors.white, colors.statusline_bg },
    },
  },
  {
    FileNameShort = {
      provider = 'FileName',
      condition = function()
        return condition.buffer_not_empty() and vim.bo.filetype ~= 'NvimTree'
      end,
      highlight = { colors.white, colors.statusline_bg },
    },
  },
}

gls.short_line_right = {
  {
    GitRootShortLeftBracket = {
      provider = BracketProvider(icons.arrow_left_filled, true),
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.statusline_bg },
    },
  },
  {
    GitRootShort = {
      provider = get_git_root,
      condition = condition.buffer_not_empty,
      icon = '  ' .. icons.file .. ' ',
      highlight = { colors.statusline_bg, colors.white },
    },
  },
  {
    GitRootShortRightBracket = {
      provider = BracketProvider(icons.rounded_right_filled, true),
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.statusline_bg },
    },
  },
}
