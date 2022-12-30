<h1 align="center">💫 CosmicNvim</h1>

<p align="center">
  <img alt="Neovim Minimum Version" src="https://img.shields.io/badge/Neovim-0.8.0+-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=white)](https://github.com/neovim/neovim">
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
- 🔧 Formatting/linting thanks to [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim)

#### Additional features

- Custom rename and code action popups via [Cosmic-UI](https://github.com/CosmicNvim/cosmic-ui)
- Amazing default theme via [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- UI enhancements via [noice](https://github.com/folke/noice.nvim)
- Enhanced syntax highlighting via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Dashboard via [dashboard-nvim](https://github.com/glepnir/dashboard-nvim)
- Custom statusline via [lualine](https://github.com/nvim-lualine/lualine.nvim)
- Explore files via [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- Fuzzy finder via [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- Floating terminal with [vim-floaterm](https://github.com/voldikss/vim-floaterm)
- Auto LSP/formatter/linter installation via [mason.nvim](https://github.com/williamboman/mason.nvim)
- Autocompletion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Additional TypeScript support via [nvim-lsp-ts-utils](https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils)
- Snippet support via [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- Session management via [auto-session](https://github.com/rmagatti/auto-session)
- Additional custom highlighting
- Floating windows for references, renaming, diagnostics, code actions and more!

_While CosmicNvim is geared specifically toward TypeScript/JavaScript development, it should be able to provide a great
experience with any LSP supported language._

## 🛠 Installation

### Quick guide

#### Prerequisites

- Neovim (+0.8.0)
- [Node.js](https://nodejs.org/en/)
- [prettierd](https://github.com/fsouza/prettierd) (for prettier formatting w/null_ls, optional)
- [eslint_d](https://www.npmjs.com/package/eslint_d) (for eslint w/null_ls, optional)

#### Install

```bash
  # move to config dir
  cd ~/.config
  # back up current config
  cp -r nvim nvim.backup
  # clone repository
  git clone git@github.com:CosmicNvim/CosmicNvim.git nvim
  # open nvim and install plugins
  nvim
```

By default, this will assume the Cosmic git directory is placed at `vim.fn.stdpath('config')`, i.e. `~/.config/nvim`.
If you are symlinking your pulled repo to `~/.config/nvim`, you must define the shell environment variable
`COSMICNVIM_INSTALL_DIR` that points to your installation.

Additional CosmicNvim installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installation).

Additional LSP server installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installing-LSP-servers).

CosmicNvim uninstallation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Uninstalling-CosmicNvim).

## 🎨 Theming

_New documentation coming soon!_

## ⚙️ Configuration

[General Info](./lua/cosmic/config/examples/readme.md)

[Cosmic configurations](./lua/cosmic/config/examples/config.lua)

[Add additional vim options](./lua/cosmic/config/examples/editor.lua)

## ✨ Cosmic Commands

### Update CosmicNvim

Updates CosmicNvim to the latest version

```vimcommand
:CosmicUpdate
```

## 🗺 Default Mappings

[File navigation](./lua/cosmic/plugins/telescope/mappings.lua)

[File explorer](./lua/cosmic/plugins/nvim-tree/mappings.lua)

[Terminal](./lua/cosmic/plugins/terminal/mappings.lua)

[LSP](./lua/cosmic/lsp/mappings.lua)

[Other](./lua/cosmic/mappings.lua)

## 📷 Screenshots

[See more](https://github.com/CosmicNvim/CosmicNvim/wiki/Screenshots)
