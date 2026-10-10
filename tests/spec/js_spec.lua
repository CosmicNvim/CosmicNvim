local T = require('tests.harness')

--- A project directory with the given files.
---@param files table<string, string[]>
---@return string
local function project(files)
  local root = T.tmpdir()
  T.write(root .. '/.git/HEAD', { 'ref: refs/heads/main' })
  for name, lines in pairs(files) do
    T.write(root .. '/' .. name, lines)
  end
  return root
end

local eslint_config = { 'export default [];' }

return {
  {
    name = 'projects pick their own linters and formatter',
    run = function()
      local js = require('cosmic.utils.js')
      local cases = {
        { 'nothing configured', {}, 'oxfmt', { eslint = false, oxlint = true } },
        {
          'oxlint and oxfmt configs',
          { ['.oxlintrc.json'] = { '{}' }, ['.oxfmtrc.json'] = { '{}' } },
          'oxfmt',
          { eslint = false, oxlint = true },
        },
        {
          'oxfmt and oxlint as dependencies in an ESLint project',
          {
            ['eslint.config.mjs'] = eslint_config,
            ['package.json'] = { '{ "devDependencies": { "oxfmt": "*", "oxlint": "*" } }' },
          },
          'oxfmt',
          { eslint = true, oxlint = true },
        },
        {
          'ESLint and Prettier configs',
          { ['eslint.config.mjs'] = eslint_config, ['.prettierrc'] = { '{}' } },
          'prettier',
          { eslint = true, oxlint = false },
        },
        {
          'Prettier configured in package.json',
          { ['.eslintrc.json'] = { '{}' }, ['package.json'] = { '{ "prettier": { "semi": false } }' } },
          'prettier',
          { eslint = true, oxlint = false },
        },
        {
          'Prettier as a dependency without a config',
          {
            ['eslint.config.js'] = eslint_config,
            ['package.json'] = { '{ "devDependencies": { "prettier": "^3" } }' },
          },
          'prettier',
          { eslint = true, oxlint = false },
        },
        {
          'ESLint configured in package.json, no Prettier',
          { ['package.json'] = { '{ "eslintConfig": { "rules": {} } }' } },
          nil,
          { eslint = true, oxlint = false },
        },
        {
          'ESLint dependency without a config',
          { ['package.json'] = { '{ "devDependencies": { "eslint": "^9" } }' } },
          'oxfmt',
          { eslint = false, oxlint = true },
        },
        {
          'migrating from ESLint and Prettier to oxlint and oxfmt',
          {
            ['eslint.config.mjs'] = eslint_config,
            ['.prettierrc'] = { '{}' },
            ['.oxlintrc.json'] = { '{}' },
            ['.oxfmtrc.json'] = { '{}' },
          },
          'oxfmt',
          { eslint = true, oxlint = true },
        },
      }
      for _, case in ipairs(cases) do
        local root = project(case[2])
        T.eq(js.formatter(root .. '/src/index.ts'), case[3], case[1] .. ': formatter')
        T.eq(js.linters(root), case[4], case[1] .. ': linters')
      end

      -- Monorepo packages inherit tooling configured at the repository root.
      local root = project({
        ['package.json'] = { '{ "devDependencies": { "prettier": "^3" } }' },
        ['eslint.config.mjs'] = eslint_config,
        ['packages/app/package.json'] = { '{ "name": "app" }' },
      })
      T.eq(js.formatter(root .. '/packages/app/src'), 'prettier', 'monorepo package: formatter')
      T.eq(js.linters(root .. '/packages/app').eslint, true, 'monorepo package: eslint')
    end,
  },
  {
    name = 'the oxlint server stays out of ESLint projects',
    run = function()
      local root_dir = vim.lsp.config.oxlint.root_dir
      local function started_in(root)
        local file = root .. '/index.ts'
        T.write(file, { 'export {}' })
        vim.cmd.edit(file)
        local started, dir = false, nil
        root_dir(vim.api.nvim_get_current_buf(), function(d)
          started, dir = true, d
        end)
        return started, dir
      end

      T.eq(started_in(project({ ['eslint.config.mjs'] = eslint_config })), false, 'ESLint project')
      local plain = project({ ['package.json'] = { '{}' } })
      local started, dir = started_in(plain)
      T.eq(started, true, 'project without a linter')
      T.eq(vim.uv.fs_realpath(dir), vim.uv.fs_realpath(plain), 'project root')
    end,
  },
}
