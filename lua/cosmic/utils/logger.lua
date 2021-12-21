local utils = require('cosmic.utils')
local Logger = {}
Logger.__index = Logger

local title = 'CosmicNvim'

function Logger:log(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.INFO,
    utils.merge({
      title = title,
    }, opts)
  )
end

function Logger:warn(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.WARN,
    utils.merge({
      title = title,
    }, opts)
  )
end

function Logger:error(msg, opts)
  opts = opts or {}
  vim.notify(
    msg,
    vim.log.levels.ERROR,
    utils.merge({
      title = title,
    }, opts)
  )
end

return Logger
