---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  settings = {
    ['js/ts'] = {
      preferences = {
        importModuleSpecifier = 'project-relative',
        preferTypeOnlyAutoImports = true,
      },
    },
  },
}
