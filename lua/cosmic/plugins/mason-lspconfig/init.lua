local user_config = require('cosmic.core.user')
local u = require('cosmic.utils')

local function get_server_filetypes(server_name, config_opt)
  if type(config_opt) == 'table' and type(config_opt.opts) == 'table' and type(config_opt.opts.filetypes) == 'table' then
    return config_opt.opts.filetypes
  end

  local server_config = vim.lsp.config[server_name]
  if server_config and type(server_config.filetypes) == 'table' then
    return server_config.filetypes
  end

  return nil
end

-- set up lsp servers
return {
  'williamboman/mason-lspconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local default_config = require('cosmic.lsp.servers.defaults')
    local configured_servers = {}
    local pending_servers = {}

    local function setup_server(user_server)
      if configured_servers[user_server] then
        return
      end

      local server_config = vim.deepcopy(default_config)

      -- set up default cosmic options
      local ok, cosmic_server_config = pcall(require, 'cosmic.lsp.servers.' .. user_server)
      if ok then
        server_config = u.merge(server_config, cosmic_server_config)
      end

      -- override options if user defines them
      if type(user_config.lsp.servers[user_server]) == 'table' and user_config.lsp.servers[user_server].opts ~= nil then
        server_config = u.merge(server_config, user_config.lsp.servers[user_server].opts)
      end

      vim.lsp.config(user_server, server_config)
      vim.lsp.enable(user_server)
      configured_servers[user_server] = true
      pending_servers[user_server] = nil
    end

    local function setup_servers_for_filetype(filetype)
      if filetype == '' then
        return
      end

      local servers_to_setup = {}
      for user_server, filetypes in pairs(pending_servers) do
        if type(filetypes) == 'table' and vim.tbl_contains(filetypes, filetype) then
          table.insert(servers_to_setup, user_server)
        end
      end

      for _, user_server in ipairs(servers_to_setup) do
        setup_server(user_server)
      end
    end

    for user_server, config_opt in pairs(user_config.lsp.servers) do
      if config_opt ~= false then
        local filetypes = get_server_filetypes(user_server, config_opt)
        if filetypes == nil or vim.tbl_isempty(filetypes) then
          setup_server(user_server)
        else
          pending_servers[user_server] = filetypes
        end
      end
    end

    if next(pending_servers) == nil then
      return
    end

    local lsp_filetype_augroup = vim.api.nvim_create_augroup('CosmicNvimLspServerSetup', { clear = true })
    local lsp_filetype_autocmd = nil
    lsp_filetype_autocmd = vim.api.nvim_create_autocmd('FileType', {
      group = lsp_filetype_augroup,
      callback = function(args)
        setup_servers_for_filetype(args.match)

        if next(pending_servers) == nil and lsp_filetype_autocmd ~= nil then
          vim.api.nvim_del_autocmd(lsp_filetype_autocmd)
        end
      end,
    })

    -- If filetypes are already set (e.g. existing buffers), initialize them immediately.
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        setup_servers_for_filetype(vim.bo[bufnr].filetype)
      end
    end
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig',   lazy = true },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
  },
}
