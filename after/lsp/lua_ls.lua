---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      hint = {
        enable = true,
        paramName = 'Literal',
        setType = true,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      -- lazydev.nvim adds the Neovim runtime and plugin libraries to the workspace
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
