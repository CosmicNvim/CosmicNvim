# Configuration

There are two main configuration files that you may want to create.

- lua/cosmic/config/config.lua
- lua/cosmic/config/editor.lua

Please look at the examples in this directory in order to get started.

Plugin customization lives in `lua/cosmic/config/config.lua`:

- `plugins.add`
- `plugins.disable` (repository IDs, e.g. `nvim-lualine/lualine.nvim`)
- `plugins.opts`
- `plugins.override`

`disable_builtin_plugins` has been removed.

## Quick Start

```bash
# from project root
cp ./lua/cosmic/config/examples/config.lua ./lua/cosmic/config/config.lua
cp ./lua/cosmic/config/examples/editor.lua ./lua/cosmic/config/editor.lua
```
