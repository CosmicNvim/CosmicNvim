# LSP Config Merging

CosmicNvim uses Neovim 0.13's `vim.lsp.config()` and `vim.lsp.enable()` APIs.
That means LSP setup is driven by named configs on `runtimepath`, not by calling
`require('lspconfig').SERVER.setup(...)`.

## Short Version

For an enabled server such as `rust_analyzer`, the effective config is built in
this order:

1. Neovim global defaults from `vim.lsp.config('*', ...)`, if any
2. `nvim-lspconfig`'s `lsp/<server>.lua`
3. Cosmic's `after/lsp/<server>.lua`, if present
4. User overrides from `lsp.servers.<server>` in `lua/cosmic/config/config.lua`

Later layers win.

After the config is resolved, Cosmic enables the server with `vim.lsp.enable()`.

## What Cosmic Does

Cosmic normalizes user LSP settings in
[`lua/cosmic/core/user.lua`](../lua/cosmic/core/user.lua).
Enabled servers end up in `user_config.lsp.resolved_servers`.

Then
[`lua/cosmic/plugins/mason-lspconfig/init.lua`](../lua/cosmic/plugins/mason-lspconfig/init.lua)
does three things:

1. Collects the enabled server names
2. Registers user overrides with `vim.lsp.config(server_name, user_override)`
3. Tells Mason to install those servers
4. Enables those servers with `vim.lsp.enable()`

This means `lsp.servers.NAME` controls all of the following:

- whether a server is enabled
- whether Mason installs it, unless `mason = false` is set
- which user overrides get merged in

## Where Base Server Config Comes From

The base server config usually comes from `nvim-lspconfig`.
For example, `rust_analyzer` is defined by `nvim-lspconfig` in
`lsp/rust_analyzer.lua` on Neovim's `runtimepath`. In a typical local install,
that file lives under `~/.local/share/nvim/lazy/nvim-lspconfig/lsp/`.

That file provides the normal `cmd`, `filetypes`, `root_dir`, `settings`, and
other defaults for the server.

Cosmic may add another layer in:

- [`after/lsp/<server>.lua`](../after/lsp/)

Those files are where Cosmic keeps built-in server-specific tweaks.

## Why `vim.lsp.config()` Picks This Up Automatically

Neovim resolves named LSP configs from `runtimepath`.
When code accesses `vim.lsp.config['rust_analyzer']`, Neovim looks for every:

- `lsp/rust_analyzer.lua`

on `runtimepath`, loads the returned tables, and deep-merges them together.

Then it deep-merges any explicit override passed through:

```lua
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})
```

So this:

```lua
vim.lsp.config('rust_analyzer', {})
```

does not mean "empty config".
It means "use the resolved runtime config for `rust_analyzer`, with no extra
user overrides".

## How `lsp.servers` Maps to Behavior

### `true`

```lua
lsp = {
  servers = {
    rust_analyzer = true,
  },
}
```

This means:

- Mason installs `rust_analyzer`
- Neovim resolves the named config from `nvim-lspconfig` and `after/lsp`
- Cosmic enables the server with no extra user overrides

### `false`

```lua
lsp = {
  servers = {
    eslint = false,
  },
}
```

This means:

- the server is removed from Cosmic's enabled set
- Mason does not install it
- `vim.lsp.enable()` is not called for it

### Table Override

```lua
lsp = {
  servers = {
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
  },
}
```

This means:

- Mason installs `rust_analyzer`
- the default config from `nvim-lspconfig` and `after/lsp` is still used
- your table is merged on top of that config

Cosmic also supports a few metadata fields that are stripped before calling
`vim.lsp.config()`:

- `format_on_save = false` disables only automatic LSP formatting on save for that server.
- `formatting = false` disables all LSP formatting from that server, including manual formatting.
- `mason = false` enables the server without passing it to Mason for installation.

For example, a local/custom server can opt out of Mason:

```lua
lsp = {
  servers = {
    my_custom_lsp = {
      mason = false,
      cmd = { 'my-custom-lsp' },
      filetypes = { 'foo' },
    },
  },
}
```

## Merge Example

If all of these exist:

- `nvim-lspconfig/lsp/rust_analyzer.lua`
- `after/lsp/rust_analyzer.lua`
- `lsp.servers.rust_analyzer = { ... }`

then the final config is effectively:

```lua
vim.tbl_deep_extend(
  'force',
  runtime_defaults,
  cosmic_after_lsp_defaults,
  user_overrides
)
```

The user table wins over Cosmic defaults, and Cosmic defaults win over plain
`nvim-lspconfig` defaults.

## Mason Installation

Cosmic treats Mason as the automatic installation path for enabled LSP servers by default.
`mason-lspconfig` expects `lspconfig` server names in `ensure_installed`, so enabled
servers are passed through to Mason unless their config has `mason = false`.

That keeps the default model simple:

- enable a server in `lsp.servers`
- Mason installs it, unless `mason = false`
- Cosmic registers the merged config
- Cosmic enables it

If Mason finishes installing a server after startup, existing buffers may need
to be reopened or restarted with `:LspRestart` before that server attaches.

## Practical Guidance

- Put built-in server defaults in `after/lsp/<server>.lua`
- Put personal overrides in `lua/cosmic/config/config.lua`
- Use `lsp.servers.NAME = true` when `nvim-lspconfig` defaults are enough
- Use `lsp.servers.NAME = { ... }` when you need extra settings
- Use `lsp.servers.NAME = false` to disable a built-in default server
