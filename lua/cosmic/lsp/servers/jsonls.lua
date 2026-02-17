---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
local opts = {
  settings = {},
  on_new_config = function(new_config)
    local ok, schemastore = pcall(require, 'schemastore')
    if not ok then
      return
    end

    new_config.settings = new_config.settings or {}
    new_config.settings.json = new_config.settings.json or {}
    new_config.settings.json.schemas = schemastore.json.schemas()
  end,
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
        end,
      },
    },
  },
}

return opts
