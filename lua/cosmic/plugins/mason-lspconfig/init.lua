return {
  'williamboman/mason-lspconfig.nvim',
  config = function()
    local user_config = require('cosmic.core.user')
    require('mason').setup({
      ui = {
        border = user_config.border,
      },
    })
    require('mason-lspconfig').setup({
      ensure_installed = user_config.lsp.ensure_installed,
    })

    -- set up lsp servers
    local u = require('cosmic.utils')
    local default_config = require('cosmic.lsp.providers.defaults')
    local lspconfig = require('lspconfig')

    local start_server = function(server)
      -- null_ls doesn't need/can't to be started via lspconfig
      if server == 'null_ls' then
        return
      end

      local opts = default_config

      -- set up default cosmic options
      if server == 'tsserver' then
        opts = u.merge(opts, require('cosmic.lsp.providers.tsserver'))
      elseif server == 'jsonls' then
        opts = u.merge(opts, require('cosmic.lsp.providers.jsonls'))
      elseif server == 'pyright' then
        opts = u.merge(opts, require('cosmic.lsp.providers.pyright'))
      elseif server == 'lua_ls' then
        opts = u.merge(opts, require('cosmic.lsp.providers.lua_ls'))
      end

      -- override options if user definds them
      if type(user_config.lsp.servers[server]) == 'table' then
        if user_config.lsp.servers[server].opts ~= nil then
          opts = u.merge(opts, user_config.lsp.servers[server].opts)
        end
      end

      lspconfig[server].setup(opts)
    end

    for config_server, config_opt in pairs(user_config.lsp.servers) do
      if not config_opt == false then
        start_server(config_server)
      end
    end

    -- See: https://github.com/neovim/neovim/issues/23291
    --[[ local watch_type = require('vim._watch').FileChangeType ]]
    --[[]]
    --[[ local function handler(res, callback) ]]
    --[[   if not res.files or res.is_fresh_instance then ]]
    --[[     return ]]
    --[[   end ]]
    --[[]]
    --[[   for _, file in ipairs(res.files) do ]]
    --[[     local path = res.root .. '/' .. file.name ]]
    --[[     local change = watch_type.Changed ]]
    --[[     if file.new then ]]
    --[[       change = watch_type.Created ]]
    --[[     end ]]
    --[[     if not file.exists then ]]
    --[[       change = watch_type.Deleted ]]
    --[[     end ]]
    --[[     callback(path, change) ]]
    --[[   end ]]
    --[[ end ]]
    --[[]]
    --[[ local function watchman(path, opts, callback) ]]
    --[[   vim.system({ 'watchman', 'watch', path }):wait() ]]
    --[[]]
    --[[   local buf = {} ]]
    --[[   local sub = vim.system({ ]]
    --[[     'watchman', ]]
    --[[     '-j', ]]
    --[[     '--server-encoding=json', ]]
    --[[     '-p', ]]
    --[[   }, { ]]
    --[[     stdin = vim.json.encode({ ]]
    --[[       'subscribe', ]]
    --[[       path, ]]
    --[[       'nvim:' .. path, ]]
    --[[       { ]]
    --[[         expression = { 'anyof', { 'type', 'f' }, { 'type', 'd' } }, ]]
    --[[         fields = { 'name', 'exists', 'new' }, ]]
    --[[       }, ]]
    --[[     }), ]]
    --[[     stdout = function(_, data) ]]
    --[[       if not data then ]]
    --[[         return ]]
    --[[       end ]]
    --[[       for line in vim.gsplit(data, '\n', { plain = true, trimempty = true }) do ]]
    --[[         table.insert(buf, line) ]]
    --[[         if line == '}' then ]]
    --[[           local res = vim.json.decode(table.concat(buf)) ]]
    --[[           handler(res, callback) ]]
    --[[           buf = {} ]]
    --[[         end ]]
    --[[       end ]]
    --[[     end, ]]
    --[[     text = true, ]]
    --[[   }) ]]
    --[[]]
    --[[   return function() ]]
    --[[     sub:kill('sigint') ]]
    --[[   end ]]
    --[[ end ]]
    --[[]]
    --[[ if vim.fn.executable('watchman') == 1 then ]]
    --[[   require('vim.lsp._watchfiles')._watchfunc = watchman ]]
    --[[ end ]]
  end,
  dependencies = {
    'williamboman/mason.nvim',
  },
  event = 'BufEnter',
}
