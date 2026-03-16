local M = {}

---@param err unknown
---@param module_name string
---@return boolean
function M.module_not_found(err, module_name)
  return type(err) == 'string' and err:find(("module '%s' not found"):format(module_name), 1, true) ~= nil
end

---@param module_name string
---@return any|nil
function M.optional_require(module_name)
  local ok, value = pcall(require, module_name)
  if ok then
    return value
  end

  if M.module_not_found(value, module_name) then
    return nil
  end

  error(value, 0)
end

return M
