local M = {}
local short_cwd_cache = ''

local function refresh_short_cwd_cache()
  local parts = vim.split(vim.fn.getcwd(), '/')
  short_cwd_cache = parts[#parts] or ''
end

refresh_short_cwd_cache()

local cwd_cache_augroup = vim.api.nvim_create_augroup('CosmicNvimCwdCache', { clear = true })
vim.api.nvim_create_autocmd('DirChanged', {
  group = cwd_cache_augroup,
  callback = refresh_short_cwd_cache,
})

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
function M.set_keymap(mode, lhs, rhs, opts)
  local defaults = {
    silent = true,
    noremap = true,
  }
  vim.keymap.set(mode, lhs, rhs, M.merge(defaults, opts or {}))
end

---@param bufnr number
---@param opts? vim.keymap.set.Opts
---@return fun(mode:string|string[], lhs:string, rhs:string|function, map_opts?:vim.keymap.set.Opts)
function M.create_buf_map(bufnr, opts)
  return function(mode, lhs, rhs, map_opts)
    M.set_keymap(
      mode,
      lhs,
      rhs,
      M.merge({
        buffer = bufnr,
      }, opts or {}, map_opts or {})
    )
  end
end

---Append items from `tbl2` into `tbl1` in place.
---@param tbl1 table
---@param tbl2? table
---@return table
function M.merge_list(tbl1, tbl2)
  if tbl2 == nil then
    return tbl1
  end

  for _, v in ipairs(tbl2) do
    table.insert(tbl1, v)
  end
  return tbl1
end

---@param ... table
---@return table
function M.merge(...)
  return vim.tbl_deep_extend('force', ...)
end

---@param str? string
---@param sep? string
---@return string[]
function M.split(str, sep)
  if type(str) ~= 'string' or str == '' then
    return {}
  end

  if type(sep) ~= 'string' or sep == '' then
    return { str }
  end

  local parts = vim.split(str, sep, {
    plain = true,
    trimempty = false,
  })

  local res = {}
  for _, part in ipairs(parts) do
    if part ~= '' then
      table.insert(res, part)
    end
  end

  return res
end

---@param path? string
---@return string
function M.get_short_file_path(path)
  if type(path) ~= 'string' or path == '' then
    return ''
  end

  local dirs = vim.split(path, '/', { plain = true, trimempty = true })

  local n = #dirs
  if n > 3 then
    return '../' .. dirs[n - 2] .. '/' .. dirs[n - 1] .. '/' .. dirs[n]
  end

  return path
end

---@return string
function M.get_short_cwd()
  return short_cwd_cache
end

---@return {added: integer, modified: integer, removed: integer}|nil
function M.diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

---@return string
function M.show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  end

  return 'Recording @' .. recording_register
end

return M
