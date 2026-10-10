---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  -- Lint with oxlint where the project uses it or no linter at all, leaving ESLint projects to ESLint.
  -- nvim-lspconfig's root_dir would also start it, without a root, in projects that don't use oxlint.
  root_dir = function(bufnr, on_dir)
    if not require('cosmic.utils.js').linters(vim.api.nvim_buf_get_name(bufnr)).oxlint then
      return
    end
    on_dir(
      vim.fs.root(bufnr, { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' })
        or vim.fs.root(bufnr, { 'package.json', '.git' })
    )
  end,
}
