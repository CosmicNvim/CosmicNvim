---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  settings = {
    basedpyright = {
      analysis = {
        --[[ diagnosticMode = 'workspace', ]]
        --[[ typeCheckingMode = "basic", ]]
        --[[ useLibraryCodeForTypes = true, ]]
        ignore = { '*' },
      },
      disableOrganizeImports = true,
    },
  }
}
