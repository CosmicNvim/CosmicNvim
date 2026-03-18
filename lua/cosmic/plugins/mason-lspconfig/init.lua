local user_config = require('cosmic.core.user')

local function get_server_filetypes(server_name, server_config)
  if type(server_config) == 'table' and type(server_config.filetypes) == 'table' then
    return server_config.filetypes
  end

  local registered_config = vim.lsp.config[server_name]
  if registered_config and type(registered_config.filetypes) == 'table' then
    return registered_config.filetypes
  end

  return nil
end

-- set up lsp servers
return {
  'williamboman/mason-lspconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local configured_servers = {}
    local pending_servers = {}
    local resolved_servers = user_config.lsp.resolved_servers

    local function setup_server(server_name)
      if configured_servers[server_name] then
        return
      end

      local server_config = resolved_servers[server_name]
      if server_config == nil then
        return
      end

      vim.lsp.config(server_name, vim.deepcopy(server_config))
      vim.lsp.enable(server_name)
      configured_servers[server_name] = true
      pending_servers[server_name] = nil
    end

    local function setup_servers_for_filetype(filetype)
      if filetype == '' then
        return
      end

      local servers_to_setup = {}
      for server_name, filetypes in pairs(pending_servers) do
        if type(filetypes) == 'table' and vim.tbl_contains(filetypes, filetype) then
          table.insert(servers_to_setup, server_name)
        end
      end

      for _, server_name in ipairs(servers_to_setup) do
        setup_server(server_name)
      end
    end

    for server_name, server_config in pairs(resolved_servers) do
      local filetypes = get_server_filetypes(server_name, server_config)
      if filetypes == nil or vim.tbl_isempty(filetypes) then
        setup_server(server_name)
      else
        pending_servers[server_name] = filetypes
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
    { 'saghen/blink.cmp', lazy = true },
    { 'neovim/nvim-lspconfig', lazy = true },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
  },
}
