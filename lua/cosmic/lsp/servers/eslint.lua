---@diagnostic disable: missing-fields

---@type vim.lsp.ClientConfig
return {
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 1000,
    exit_timeout = 1500,
  },
}
