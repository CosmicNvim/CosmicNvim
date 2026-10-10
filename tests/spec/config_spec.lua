local T = require('tests.harness')

--- Re-evaluate cosmic.core.user against a different config.lua.
---@param config table
---@return CosmicUserConfig
local function load_user_config(config)
  package.loaded['cosmic.core.user'] = nil
  package.loaded['cosmic.config.config'] = nil
  package.preload['cosmic.config.config'] = function()
    return config
  end
  return require('cosmic.core.user')
end

return {
  {
    name = 'lsp.servers.NAME = true keeps Cosmic defaults for that server',
    run = function()
      local user = load_user_config({ lsp = { servers = { tsc = true, ruff = true } } })
      T.eq(user.lsp.format_on_save_disabled.tsc, true, 'tsc format_on_save disabled')
      T.eq(user.lsp.format_on_save_disabled.ruff, true, 'ruff format_on_save disabled')
    end,
  },
  {
    name = 'server tables merge with defaults, false disables a server',
    run = function()
      local user = load_user_config({
        lsp = {
          servers = {
            tsc = { flags = { debounce_text_changes = 150 } },
            ruff = { format_on_save = true },
            eslint = false,
          },
        },
      })
      T.eq(user.lsp.format_on_save_disabled.tsc, true, 'tsc keeps format_on_save = false')
      T.eq(user.lsp.resolved_servers.tsc.flags, { debounce_text_changes = 150 }, 'tsc flags')
      T.eq(user.lsp.format_on_save_disabled.ruff, nil, 'ruff opted back in')
      T.eq(user.lsp.resolved_servers.eslint, nil, 'eslint disabled')
      T.eq(user.lsp.resolved_servers.tsc.format_on_save, nil, 'Cosmic metadata stripped from LSP config')
    end,
  },
  {
    name = 'mason = false enables a server without installing it',
    config = { lsp = { servers = { my_server = { mason = false, cmd = { 'my-server' }, filetypes = { 'foo' } } } } },
    run = function()
      T.truthy(vim.lsp.is_enabled('my_server'), 'my_server enabled')
      local ensure_installed = T.mason_lspconfig_opts.ensure_installed
      T.eq(vim.tbl_contains(ensure_installed, 'my_server'), false, 'my_server passed to Mason')
      T.truthy(vim.tbl_contains(ensure_installed, 'lua_ls'), 'default servers passed to Mason')
    end,
  },
  {
    name = 'invalid options are reported and replaced with defaults',
    run = function()
      local cases = {
        { { lsp = { format_timeout = 0 } }, '`lsp.format_timeout` must be a positive number' },
        { { lsp = { inlay_hint = 'yes' } }, '`lsp.inlay_hint` must be `true` or `false`' },
        { { lsp = { servers = { 'rust_analyzer' } } }, 'for example `rust_analyzer = true`' },
        { { lsp = { servers = { tsc = { mason = 'no' } } } }, '`lsp.servers.tsc.mason` must be `true` or `false`' },
        { { lsp = { servers = { tsc = { opts = {} } } } }, '`lsp.servers.tsc.opts` is not supported' },
        { { plugins = { name = 'not a list' } }, '`plugins` must be a list' },
      }
      for _, case in ipairs(cases) do
        local notes = T.capture_notifications()
        local user = load_user_config(case[1])
        vim.wait(100)
        T.eq(#notes, 1, 'notification count for ' .. case[2])
        T.truthy(notes[1].msg:find(case[2], 1, true), notes[1].msg)
        T.eq(user.lsp.format_timeout, 3000, 'defaults used for ' .. case[2])
      end
    end,
  },
}
