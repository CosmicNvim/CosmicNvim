# Configuration

There are two main configuration files that you may want to create.

- lua/cosmic/config/config.lua
- lua/cosmic/config/editor.lua

Please look at the examples in this directory in order to get started.

Plugin customization lives in `lua/cosmic/config/config.lua`:

- `plugins = { ... }` for direct lazy.nvim specs
- disable built-in plugins with `{ 'repo/name', enabled = false }`
- override built-in plugins by adding another spec for the same repository ID
- configure LSP server enablement and overrides under `lsp.servers.NAME`

Cosmic's built-in LSP server defaults come from `nvim-lspconfig` and `after/lsp/*.lua`. User config under
`lsp.servers.NAME` is merged on top of those defaults for enabled servers.

Enabled servers are installed through Mason automatically.
Enabled servers are enabled by Cosmic with `vim.lsp.enable()`.

`disable_builtin_plugins`, `plugins.add`, `plugins.disable`, `plugins.opts`, `plugins.override`, and `lsp.servers.NAME.opts` have been removed.

## Quick Start

```bash
# from project root
cp ./lua/cosmic/config/examples/config.lua ./lua/cosmic/config/config.lua
cp ./lua/cosmic/config/examples/editor.lua ./lua/cosmic/config/editor.lua
```
