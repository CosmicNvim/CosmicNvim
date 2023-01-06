local augroup_name = 'CosmicNvimLspFormat'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
local user_config = require('cosmic.core.user')

if user_config.lsp.format_on_save then
  local format_filetypes = ''
  if vim.tbl_islist(user_config.lsp.format_on_save) then
    for _, ft in pairs(user_config.lsp.format_on_save) do
      format_filetypes = format_filetypes .. '*' .. ft
    end
  else
    format_filetypes = '*'
  end

  vim.api.nvim_create_autocmd(string.format('BufWritePre %s', format_filetypes), {
    callback = function()
      vim.lsp.buf.format({
        timeout_ms = user_config.lsp.format_timeout,
        -- check user config to see if we can format on save
        filter = function(client)
          return user_config.lsp.can_client_format(client.name)
        end,
      })
    end,
    group = group,
    nested = true,
  })
end
