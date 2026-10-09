---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
local opts = {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  -- Resolve SchemaStore schemas when the client starts so the plugin only loads for JSON buffers.
  -- Mutate the existing settings table: the client sends this same table to the server.
  before_init = function(_, config)
    local ok, schemastore = pcall(require, 'schemastore')
    if not ok then
      return
    end

    config.settings.json = config.settings.json or {}
    -- User-provided schemas come last so they can extend SchemaStore's catalog.
    config.settings.json.schemas = vim.list_extend(schemastore.json.schemas(), config.settings.json.schemas or {})
  end,
}

return opts
