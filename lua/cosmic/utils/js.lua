-- Detects the JavaScript linters and formatter a project uses, so Cosmic runs the project's own tools.
-- Projects without any JavaScript tooling configured get oxlint and oxfmt.
local M = {}

---@alias cosmic.JsTool 'eslint'|'oxfmt'|'oxlint'|'prettier'

---@type table<cosmic.JsTool, string[]>
local config_files = {
  eslint = {
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
  },
  oxfmt = { '.oxfmtrc.json', '.oxfmtrc.jsonc' },
  oxlint = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' },
  prettier = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.json5',
    '.prettierrc.yaml',
    '.prettierrc.yml',
    '.prettierrc.toml',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.mjs',
    '.prettierrc.ts',
    '.prettierrc.cts',
    '.prettierrc.mts',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs',
    'prettier.config.ts',
    'prettier.config.cts',
    'prettier.config.mts',
  },
}

-- package.json keys that hold a tool's configuration
local package_json_config = { eslint = 'eslintConfig', prettier = 'prettier' }

-- Tools that work without a config file, so depending on them is enough. ESLint 9 needs a config.
local dependency_tools = { 'oxfmt', 'oxlint', 'prettier' }

--- Tools a project configures or depends on, searching upward like the tools themselves do.
---@param path string file or directory in the project
---@return table<cosmic.JsTool, boolean>
function M.tools(path)
  if path == '' then
    path = assert(vim.uv.cwd())
  elseif vim.fn.isdirectory(path) == 0 then
    path = vim.fs.dirname(path)
  end

  local found = {}
  for tool, names in pairs(config_files) do
    found[tool] = vim.fs.find(names, { upward = true, path = path, type = 'file', limit = 1 })[1] ~= nil
  end

  local package_files = vim.fs.find('package.json', { upward = true, path = path, type = 'file', limit = math.huge })
  for _, package_file in ipairs(package_files) do
    local ok, manifest = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_file), '\n'))
    if ok and type(manifest) == 'table' then
      for tool, key in pairs(package_json_config) do
        found[tool] = found[tool] or manifest[key] ~= nil
      end
      for _, field in ipairs({ 'dependencies', 'devDependencies' }) do
        local dependencies = manifest[field]
        if type(dependencies) == 'table' then
          for _, tool in ipairs(dependency_tools) do
            found[tool] = found[tool] or dependencies[tool] ~= nil
          end
        end
      end
    end
  end
  return found
end

--- Formatter for the project's JavaScript, TypeScript, CSS, HTML, JSON and Markdown files. ESLint-only projects get
--- none, since ESLint enforces their style.
---@param path string
---@return 'oxfmt'|'prettier'|nil
function M.formatter(path)
  local tools = M.tools(path)
  if tools.oxfmt then
    return 'oxfmt'
  elseif tools.prettier then
    return 'prettier'
  elseif tools.eslint then
    return nil
  end
  return 'oxfmt'
end

--- Linters for the project: ESLint when it is configured, oxlint when the project uses it or no linter at all.
---@param path string
---@return { eslint: boolean, oxlint: boolean }
function M.linters(path)
  local tools = M.tools(path)
  return { eslint = tools.eslint, oxlint = tools.oxlint or not tools.eslint }
end

return M
