local Logger = {}
Logger.__index = Logger

local title = 'CosmicNvim'

Logger = {}
Logger.__index = Logger

local function log(type, msg, opts)
  local ok, notify = pcall(require, 'notify')
  if ok then
    notify(
      msg,
      type,
      vim.tbl_deep_extend('force', {
        title = title,
      }, opts)
    )
  else
    if vim.tbl_islist(msg) then
      -- regular vim.notify can't take tables of strings
      local tmp_list = msg
      msg = ''
      for _, v in pairs(tmp_list) do
        msg = msg .. v
      end
    end

    vim.notify(msg, type)
  end
end

function Logger:log(msg, opts)
  log(vim.log.levels.INFO, msg, opts or {})
end

function Logger:warn(msg, opts)
  log(vim.log.levels.WARN, msg, opts or {})
end

function Logger:error(msg, opts)
  log(vim.log.levels.ERROR, msg, opts or {})
end

return Logger
