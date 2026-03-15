# Configuration

There are two main configuration files that you may want to create.

- lua/cosmic/config/config.lua
- lua/cosmic/config/editor.lua

Please look at the examples in this directory in order to get started.

Plugin customization lives in `lua/cosmic/config/config.lua`:

- `plugins = { ... }` for direct lazy.nvim specs
- disable built-in plugins with `{ 'repo/name', enabled = false }`
- override built-in plugins by adding another spec for the same repository ID
- configure LSP servers directly under `lsp.servers.NAME`

`disable_builtin_plugins`, `plugins.add`, `plugins.disable`, `plugins.opts`, `plugins.override`, and `lsp.servers.NAME.opts` have been removed.

## Quick Start

```bash
# from project root
cp ./lua/cosmic/config/examples/config.lua ./lua/cosmic/config/config.lua
cp ./lua/cosmic/config/examples/editor.lua ./lua/cosmic/config/editor.lua
```
