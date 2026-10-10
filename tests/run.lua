-- Run the test suite: nvim -l tests/run.lua [name filter]
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
package.path = root .. '/?.lua;' .. package.path

local T = require('tests.harness')
local filter = arg[1]

---@param line string
local function say(line)
  io.stdout:write(line .. '\n')
  io.stdout:flush()
end

T.setup()
T.bootstrap()

local specs = vim.fn.glob(root .. '/tests/spec/*_spec.lua', false, true)
table.sort(specs)

local total, failed = 0, 0
for _, spec_file in ipairs(specs) do
  local spec_name = vim.fn.fnamemodify(spec_file, ':t:r'):gsub('_spec$', '')
  for index, case in ipairs(dofile(spec_file)) do
    local name = ('%s: %s'):format(spec_name, case.name)
    if not filter or name:find(filter, 1, true) then
      total = total + 1
      local started = vim.uv.hrtime()
      local ok, err = T.run_child(spec_file, index, case)
      say(('%s %s (%dms)'):format(ok and 'ok  ' or 'FAIL', name, math.floor((vim.uv.hrtime() - started) / 1e6)))
      if not ok then
        failed = failed + 1
        say('     ' .. err:gsub('\n', '\n     '))
      end
    end
  end
end

say(('\n%d passed, %d failed'):format(total - failed, failed))
if failed > 0 or total == 0 then
  os.exit(1)
end
