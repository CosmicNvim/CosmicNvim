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

<img width="2531" alt="Historical CosmicNvim screenshot from December 2021" src="https://user-images.githubusercontent.com/3721204/146691358-82a6ff64-1942-4351-ac53-e710a3e48700.png">

_Historical screenshot (December 2021); the current UI and plugin defaults differ._

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
- LSP server management via [mason.nvim](https://github.com/mason-org/mason.nvim)
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

For the corresponding features, also install:

- Tree-sitter CLI and a C compiler (`cc`, `gcc` or `clang`) for parser installation and syntax highlighting
- `make` and a C compiler for LuaSnip's regex transformations
- `ripgrep` (`rg`) for picker text searches
- `fd` 8.4+ (`fd` or `fdfind`) for file explorer searches; it also speeds up file pickers
- `curl` and `tar` for parser/package downloads and extraction
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal to display icons correctly

These support specific features rather than core startup. `:checkhealth cosmic` checks external tools after installation.

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

By default, Cosmic uses the Git checkout at `vim.fn.stdpath('config')`, usually `~/.config/nvim`.
A whole-directory symlink from that location to your checkout works without additional configuration.
If you link individual files or otherwise keep the checkout elsewhere, set the shell environment variable
`COSMICNVIM_INSTALL_DIR` to the checkout path so Cosmic can locate its lockfile and update the correct repository.
For individual-file installations, include the `after/` directory as well as `init.lua` and `lua/` so built-in LSP
settings are on Neovim's runtimepath.

After plugins finish installing, run `:checkhealth cosmic` to check the installation and external tools.

#### Formatters

Conform formats on save with the tools configured in `lua/cosmic/plugins/conform/init.lua`.
Install the tools for your filetypes and make sure Neovim can find their executables on `PATH`.
Mason's LSP installation does not install every configured formatter. Some servers, such as oxlint and Ruff,
share their executable with Conform's tools and may already provide it.

JavaScript and web files follow each project's own tooling. Linters and formatters are selected independently.
For JS/TS files, lint fixes run before formatting:

| Project's linter setup | Lint fixes on save | Linter diagnostics from |
| --- | --- | --- |
| oxlint present, no ESLint configured | `oxlint` | oxlint server |
| oxlint present and ESLint configured | `oxlint`, then `eslint_d` | Both servers |
| ESLint configured, no oxlint | `eslint_d` | ESLint server |
| Neither linter configured | `oxlint` (default) | oxlint server |

For JS/TS, CSS, SCSS, HTML, JSON and Markdown, the first matching rule selects the formatter:

| Project's formatter setup | Formatter |
| --- | --- |
| oxfmt present | `oxfmt` |
| Otherwise, Prettier present | `prettierd`; plain `prettier` is also enabled when `prettierd` is absent from `PATH` |
| Otherwise, ESLint configured | No separate web formatter; only JS/TS ESLint fixes |
| None of the above | `oxfmt` |

For example, oxlint + Prettier uses oxlint fixes and Prettier formatting, while ESLint + oxfmt uses ESLint fixes and oxfmt.
CSS, SCSS, HTML, JSON and Markdown use the formatter selection above, but do not run the JS/TS lint-fix commands.

Detection searches the file's directory and its ancestors for supported config files, such as `.prettierrc` or
`eslint.config.js`, and `package.json` settings (`eslintConfig` or `prettier`). An oxlint, oxfmt or Prettier dependency
in `dependencies` or `devDependencies` also counts; an ESLint dependency alone does not.
Conform prefers project-local binaries where supported by the tool's formatter definition.
The Prettier fallback check only looks at `PATH`: a project-local-only `prettierd` can cause both Prettier commands to run.
When no external formatter is available, Conform can fall back to an eligible LSP formatter.

| Other filetypes | Formatters, in order |
| --- | --- |
| Lua | `stylua` |
| Go | `goimports`, `gofmt` |
| Python | `ruff_fix`, `ruff_format`, `ruff_organize_imports`, all using the `ruff` executable |

For web tooling, install Node.js and npm, then install the tools globally or with Mason:

```bash
npm install -g oxlint oxfmt eslint_d @fsouza/prettierd
```

```vimcommand
:MasonInstall oxlint oxfmt eslint_d prettierd
```

For other languages, install only what you need:

- Lua: install Rust/Cargo, then run `cargo install stylua --locked`. Put `~/.cargo/bin` on `PATH`.
- Go: install Go, which includes `gofmt`, then run `go install golang.org/x/tools/cmd/goimports@latest`.
  Add `$(go env GOPATH)/bin` to `PATH`, or your `GOBIN` directory if you set one.
- Python: install [pipx](https://pipx.pypa.io/stable/installation/), then run `pipx install ruff` and `pipx ensurepath`.

Restart your shell and Neovim after changing `PATH`.
Open a source file and run `:ConformInfo` to see which formatters are available and inspect the formatter log.
Use `:checkhealth cosmic` for broader setup checks.

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

Enabled servers are installed through Mason automatically unless `lsp.servers.NAME.mason = false` is set.
With `mason = false`, install the server yourself and ensure its command is available to Neovim.
Cosmic enables configured servers with `vim.lsp.enable()` in either case.
See [LSP config merging](./docs/lsp-config-merging.md) for server configuration and installation options.

`disable_builtin_plugins`, `plugins.add`, `plugins.disable`, `plugins.opts`, `plugins.override`,
and `lsp.servers.NAME.opts` have been removed.

## ✨ Cosmic Commands

### Update CosmicNvim

Fetches CosmicNvim updates and fast-forwards your checkout without blocking the editor.

```vimcommand
:CosmicUpdate
```

- Lists the incoming commits after a successful update.
- If the update changes `lazy-lock.json` and your copy has local plugin updates, for example from `:Lazy update`,
  asks before discarding them.
- If the lockfile changed, offers to restore plugins to the updated versions.
- Failures report Git's exit code and error output.

After a successful update, restart Neovim to load the changes.

## 🧪 Contributing

Run these checks from the repository root:

```bash
nvim -l tests/run.lua
stylua --check .
npx --yes markdownlint-cli@0.49.1 '*.md' 'docs/*.md' 'lua/**/*.md'
```

The test runner installs plugins into an isolated `.tests/` directory, so your own setup is not touched.
Use `stylua .` to apply Lua formatting. CI runs all three checks on pull requests and pushes to `main`.
See [AGENTS.md](./AGENTS.md) for project conventions.

## 📷 Screenshots

[Historical screenshots](https://github.com/CosmicNvim/CosmicNvim/wiki/Screenshots) show earlier versions,
not the current UI.
