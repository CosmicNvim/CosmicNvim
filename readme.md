<h1 align="center">💫 CosmicNvim</h1>

<p align="center">
  <a href="https://github.com/neovim/neovim">
    <img alt="Neovim Minimum Version" src="https://img.shields.io/badge/Neovim-0.13.0+-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=white">
  </a>
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/CosmicNvim/CosmicNvim?style=flat-square&logo=Github">
  <a href="https://discord.gg/EwdrKzVbvJ">
    <img alt="Discord" src="https://img.shields.io/discord/901609359291854899?style=flat-square&logo=Discord">
  </a>
  <a href="https://cosmicnvim.vercel.app/">
    <img alt="Website" src="https://img.shields.io/website?style=flat-square&up_message=live&label=website&url=https%3A%2F%2Fcosmicnvim.vercel.app%2F">
  </a>
</p>

CosmicNvim is a lightweight and opinionated Neovim config for web development,
specifically designed to provide a 💫 COSMIC programming experience!

<img width="2531" alt="Screen Shot 2021-12-19 at 1 25 24 PM" src="https://user-images.githubusercontent.com/3721204/146691358-82a6ff64-1942-4351-ac53-e710a3e48700.png">

## 🚀 Stellar Features

### Native LSP

Full featured native LSP functionality!

- 📘 Go-to definition
- 🔍 Find references/type def/declaration
- 💡 Code actions
- 🚨 Statusline diagnostics
- 🔧 Formatting thanks to [conform.nvim](https://github.com/stevearc/conform.nvim)

#### Additional features

- Custom rename and code action popups via [Cosmic-UI](https://github.com/CosmicNvim/cosmic-ui)
- Amazing default theme via [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- UI enhancements via [snacks.nvim](https://github.com/folke/snacks.nvim) and [noice.nvim](https://github.com/folke/noice.nvim)
- Enhanced syntax highlighting via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Custom statusline via [lualine](https://github.com/nvim-lualine/lualine.nvim)
- File editor via [oil.nvim](https://github.com/stevearc/oil.nvim)
- Floating terminal with [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- LSP server management via [mason.nvim](https://github.com/williamboman/mason.nvim)
- Autocompletion via [blink.cmp](https://github.com/Saghen/blink.cmp)
- Snippet support via [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- Session management via [auto-session](https://github.com/rmagatti/auto-session)
- Easy to find keybindings via [which-key.nvim](https://github.com/folke/which-key.nvim)
- Floating windows for references, renaming, diagnostics, code actions and more!

_While CosmicNvim is geared specifically toward TypeScript/JavaScript development, it should be able to provide a great
experience with any LSP supported language._

## 🛠 Installation

### Quick guide

#### Prerequisites

- Neovim 0.13.0+ (Nightly)
- Git to clone CosmicNvim and install plugins
- [Node.js](https://nodejs.org/en/) with npm for JS/TS tooling
- External formatters for the languages you use, listed below

#### Install

```bash
# Create and enter Neovim's config parent directory.
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}" && cd "${XDG_CONFIG_HOME:-$HOME/.config}" || exit 1
# Move an existing config or symlink into a unique backup directory.
if [ -e nvim ] || [ -L nvim ]; then
  backup_dir=$(mktemp -d "$PWD/nvim.backup.XXXXXX") || exit 1
  mv nvim "$backup_dir/nvim" || exit 1
  printf 'Previous config saved to %s/nvim\n' "$backup_dir"
fi
# Clone into the now-empty destination, then install plugins on first launch.
git clone https://github.com/CosmicNvim/CosmicNvim.git nvim && nvim
```

By default, this will assume the Cosmic git directory is placed at `vim.fn.stdpath('config')`, i.e. `~/.config/nvim`.
If you are symlinking your pulled repo to `~/.config/nvim`, you must define the shell environment variable
`COSMICNVIM_INSTALL_DIR` that points to your installation.

After plugins finish installing, run `:checkhealth cosmic` to check the installation and external tools.

#### Formatters

Conform uses the following tools from `lua/cosmic/plugins/conform/init.lua`.
Install the tools for your filetypes and make sure Neovim can find their executables on `PATH`.
LSP server installation through Mason does not install all of these formatters.

| Filetypes | Configured formatters, in order |
| --- | --- |
| JavaScript, TypeScript, JSX, TSX | `eslint_d`, `oxlint`, `oxfmt` |
| CSS, SCSS, HTML, JSON, Markdown | `oxfmt` |
| Lua | `stylua` |
| Go | `goimports`, `gofmt` |
| Python | `ruff_fix`, `ruff_format`, `ruff_organize_imports`, all using the `ruff` executable |

For web tooling, install Node.js and npm, then run:

```bash
npm install -g eslint_d oxlint oxfmt
```

Use your project's ESLint dependency and configuration with `eslint_d`.
`prettierd` is not part of the default formatter configuration.

For other languages, install only what you need:

- Lua: install Rust/Cargo, then run `cargo install stylua --locked`. Put `~/.cargo/bin` on `PATH`.
- Go: install Go, which includes `gofmt`, then run `go install golang.org/x/tools/cmd/goimports@latest`.
  Add `$(go env GOPATH)/bin` to `PATH`, or your `GOBIN` directory if you set one.
- Python: install [pipx](https://pipx.pypa.io/stable/installation/), then run `pipx install ruff` and `pipx ensurepath`.

Restart your shell and Neovim after changing `PATH`.
Open a source file and run `:ConformInfo` to see which formatters are available and inspect the formatter log.
Use `:checkhealth cosmic` for broader setup checks.

Additional CosmicNvim installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installation).

Additional LSP server installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installing-LSP-servers).

CosmicNvim uninstallation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Uninstalling-CosmicNvim).

## ⚙️ Configuration

[General Info](./lua/cosmic/config/examples/readme.md)

[Cosmic configurations](./lua/cosmic/config/examples/config.lua)

[Add additional vim options](./lua/cosmic/config/examples/editor.lua)

[LSP config merging](./docs/lsp-config-merging.md)

Plugin customization in `lua/cosmic/config/config.lua` uses:

- `plugins = { ... }` for direct lazy.nvim specs
- `{ 'repo/name', enabled = false }` to disable a built-in plugin
- another spec with the same repository ID to override a built-in plugin
- `lsp.servers.NAME = true | false | { ... }` to enable, disable, or override an LSP server

Built-in LSP defaults come from `nvim-lspconfig` and are extended by `after/lsp/*.lua`. User config under
`lsp.servers.NAME` is merged on top of those defaults when the server is enabled.

Enabled servers are installed through Mason automatically.
Enabled servers are enabled by Cosmic with `vim.lsp.enable()`.

`disable_builtin_plugins`, `plugins.add`, `plugins.disable`, `plugins.opts`, `plugins.override`, and `lsp.servers.NAME.opts` have been removed.

## ✨ Cosmic Commands

### Update CosmicNvim

Updates CosmicNvim to the latest version

```vimcommand
:CosmicUpdate
```

## 📷 Screenshots

[See more](https://github.com/CosmicNvim/CosmicNvim/wiki/Screenshots)
