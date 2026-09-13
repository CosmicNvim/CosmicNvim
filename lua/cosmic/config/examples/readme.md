# Configuration

There are two main configuration files that you may want to create.

- `lua/cosmic/config/config.lua` for LSP, diagnostics, and plugin overrides
- `lua/cosmic/config/editor.lua` for Neovim options and additional keymaps

Both files are optional. Copying the examples unchanged preserves Cosmic's defaults.
Uncomment the examples you want to use. Rust, extra plugins, leader changes, and indentation changes are opt-in.
Set floating-window borders with `vim.opt.winborder` in `editor.lua`, not a `border` field in `config.lua`.
Plugins may override the global border option.

Plugin customization lives in `lua/cosmic/config/config.lua`:

- `plugins = { ... }` for direct lazy.nvim specs
- disable built-in plugins with `{ 'repo/name', enabled = false }`
- override built-in plugins by adding another spec for the same repository ID
- configure LSP server enablement and overrides under `lsp.servers.NAME`

Cosmic's built-in LSP server defaults come from `nvim-lspconfig` and `after/lsp/*.lua`. User config under
`lsp.servers.NAME` is merged on top of those defaults for enabled servers.

Enabled servers are installed through Mason automatically by default, unless
`lsp.servers.NAME.mason = false` is set.
Enabled servers are enabled by Cosmic with `vim.lsp.enable()`.

Cosmic supports server metadata fields that are stripped before calling
`vim.lsp.config()`:

- `format_on_save = false` disables only automatic LSP formatting on save
- `formatting = false` disables all LSP formatting from that server
- `mason = false` enables the server without asking Mason to install it

## Quick start

Run from the repository root. `cp -i` asks before overwriting an existing configuration.

```bash
cp -i ./lua/cosmic/config/examples/config.lua ./lua/cosmic/config/config.lua
cp -i ./lua/cosmic/config/examples/editor.lua ./lua/cosmic/config/editor.lua
```

Restart Neovim after changing your configuration.

## Keymaps

The default leader is Space. Snacks provides these picker mappings:

- `<leader>fp` finds files, including hidden files
- `<leader>ff` finds Git files
- `<leader>fs` searches project text

Browse mappings with `:lua Snacks.picker.keymaps()` or inspect them with `:map <leader>`.
Disable plugin mappings through a lazy.nvim `keys` override in `config.lua`.
The example config shows how to disable Snacks' `<leader>fp` mapping.

## Formatting and setup checks

See the [formatter installation guide](../../../../readme.md#formatters) for the configured tools.
LSP formatting settings above do not disable Conform's external formatters.
Run `:ConformInfo` in a source buffer to check available formatters and their logs.
Run `:checkhealth cosmic` to diagnose missing tools and setup problems.
