local Logger = {}
Logger.__index = Logger

local title = 'CosmicNvim'

function Logger:log(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.INFO,
    vim.tbl_deep_extend('force', {
      title = title,
    }, opts)
  )
end

function Logger:warn(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.WARN,
    vim.tbl_deep_extend('force', {
      title = title,
    }, opts)
  )
end

function Logger:error(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.ERROR,
    vim.tbl_deep_extend('force', {
      title = title,
    }, opts)
  )
end

return Logger
