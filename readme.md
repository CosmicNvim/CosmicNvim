<h1 align="center">💫 CosmicNvim</h1>

<p align="center">
  <img alt="Neovim Minimum Version" src="https://img.shields.io/badge/Neovim-0.6.0+-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=white)](https://github.com/neovim/neovim">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/mattleong/CosmicNvim?style=flat-square&logo=Github">
  <a target="_blank" href="https://discord.gg/EwdrKzVbvJ">
    <img alt="Discord" src="https://img.shields.io/discord/901609359291854899?style=flat-square&logo=Discord">
  </a>
  <img alt="Website" src="https://img.shields.io/website?style=flat-square&up_message=live&label=website&url=https%3A%2F%2Fcosmicnvim.vercel.app%2F">
</p>

CosmicNvim is a lightweight and opinionated Neovim config for web development, specifically designed to provide a 💫 COSMIC programming experience!

## 🚀 Stellar Features

#### Native LSP

Full featured native LSP functionality!

- 📘 Go-to definition
- 🔍 Find references/type def/declaration
- 💡 Code actions
- 🚨 Statusline diagnostics
- ⚠️ Linting thanks to [eslint](https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/eslint/README.md)
- 🔧 Formatting thanks to [efm](https://github.com/mattn/efm-langserver)

##### Additional features

- Amazing colors thanks to [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- Enhanced syntax highlighting with [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Hand-built statusline with [galaxyline](https://github.com/NTBBloodbath/galaxyline.nvim)
- Explore files with [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- Fuzzy finder and some LSP actions with [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- Floating terminal with [vim-floaterm](https://github.com/voldikss/vim-floaterm)
- Auto LSP installation with [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)
- Autocompletion provided by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Additional TypeScript support with [nvim-lsp-ts-utils](https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils)
- Snippet support via [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- Session management with [auto-session](https://github.com/rmagatti/auto-session)
- Notifications via [nvim-notify](https://github.com/rcarriga/nvim-notify)
- Additional custom highlighting
- Floating windows for references, renaming, diagnostics, code actions and more!

_While CosmicNvim is geared specifically toward TypeScript/JavaScript development, it should be able to provide a great experience with any LSP supported language._

## Installation

### Quick guide

#### Prerequisites

- Neovim (+0.6.0)
- [Node.js](https://nodejs.org/en/)
- [prettierd](https://github.com/fsouza/prettierd) (for prettier formatting w/efm, optional)
- [eslint_d](https://www.npmjs.com/package/eslint_d) (for eslint w/efm, optional)

#### Install

```
  $ cd ~/.config
  $ git clone git@github.com:mattleong/CosmicNvim.git nvim
  $ nvim .
```

Additional Cosmic installation [details](https://github.com/mattleong/CosmicNvim/wiki/Installation).

Additional LSP server installation [details](https://github.com/mattleong/CosmicNvim/wiki/Installing-LSP-servers).

## Configuration

[Cosmic configurations](./lua/cosmic/config/config-example.lua)

[Plugin configurations](./lua/cosmic/config/plugins-example.lua)

[Add additional mappings](./lua/cosmic/config/mappings-example.lua)

[Add additional vim options](./lua/cosmic/config/editor-example.lua)

## Treesitter Support

Enter `:TSInstall` followed by <TAB> to see your options for additional language support.

## Default Mappings

[File Navigation](./lua/cosmic/core/navigation/mappings.lua)

[File explorer](./lua/cosmic/core/file-explorer/mappings.lua)

[Terminal](./lua/cosmic/core/terminal/mappings.lua)

[LSP](./lua/cosmic/lsp/mappings.lua)

[Other](./lua/cosmic/mappings.lua)

## 📷 Screenshots

### Statusline

![normal](https://user-images.githubusercontent.com/3721204/137990346-8f614b6b-63da-471a-b5be-635b587f10a1.png)
![insert](https://user-images.githubusercontent.com/3721204/137990345-d036c2d1-0f9e-4d4e-bd6c-13e051609f61.png)
![visual](https://user-images.githubusercontent.com/3721204/137990348-6eb29e9b-e912-4d6e-8a5e-e763816613d7.png)
![replace](https://user-images.githubusercontent.com/3721204/137990347-b59428d6-b5fe-4edb-8ceb-ab37b69b7e76.png)

### Dashboard

<img width="1792" alt="dashboard" src="https://user-images.githubusercontent.com/3721204/140592730-fc512005-6060-4dd2-8b90-0afa865d61d3.png">

### Autocomplete

<img width="1792" alt="autocomplete" src="https://user-images.githubusercontent.com/3721204/140592713-f08c72f8-4fc5-4422-8987-2224b9425725.png">

### Rename

<img width="859" alt="rename" src="https://user-images.githubusercontent.com/3721204/140592783-c9875634-805e-45f4-8547-6dcb5b5c7404.png">

### Rename change notification

<img width="1792" alt="rename notification" src="https://user-images.githubusercontent.com/3721204/140592788-27c0f02a-e31b-4af7-8f0c-a49a988e295e.png">

### Hover

<img width="1792" alt="hover" src="https://user-images.githubusercontent.com/3721204/140592798-b9dbbdee-8496-4998-a874-110a051a7672.png">

[See more screenshots](https://github.com/mattleong/CosmicNvim/wiki/Screenshots)
