---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  settings = {
    javascript = {
      preferences = {
        importModuleSpecifier = 'project-relative',
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = 'project-relative',
        preferTypeOnlyAutoImports = true,
      },
    },
  },
}
