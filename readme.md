<h1 align="center">💫 CosmicNvim</h1>

<p align="center">
  <img alt="Neovim Minimum Version" src="https://img.shields.io/badge/Neovim-0.6.0+-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=white)](https://github.com/neovim/neovim">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/mattleong/CosmicNvim?style=flat-square&logo=Github">
  <img alt="Discord" src="https://img.shields.io/discord/901609359291854899?style=flat-square&logo=Discord">
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
- Snippet support via [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- Session management with [auto-session](https://github.com/rmagatti/auto-session)
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

[Cosmic configurations](./lua/cosmic/config/config.lua)

[Plugin configurations](./lua/cosmic/config/plugins.lua)

[Add additional mappings](./lua/cosmic/config/mappings.lua)

[Add additional vim options](./lua/cosmic/config/editor.lua)

## Treesitter Support

Enter `:TSInstall` followed by <TAB> to see your options for languages with treesitter support

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

### Autocomplete
<img width="2532" alt="autocomplete" src="https://user-images.githubusercontent.com/3721204/138015498-3b18495e-9011-4ac2-9f3f-f020feb85caf.png">

### Rename
![rename](https://user-images.githubusercontent.com/3721204/138015221-0e55c63a-b640-46e0-9353-7e891f804d67.png)

### Hover
![hover](https://user-images.githubusercontent.com/3721204/138015245-a530e565-d1cb-4d2a-bcbc-7a8109befcda.png)

### Find Reference
![reference](https://user-images.githubusercontent.com/3721204/138015259-d59fbafb-86cc-471e-bfe8-46f723da359c.png)

### Code Action
![code_action](https://user-images.githubusercontent.com/3721204/138015273-770404ea-9cf7-48cf-8a31-62d865e6fa2a.png)

### File Navigation
![find_files](https://user-images.githubusercontent.com/3721204/138015288-9d592ebd-cfe0-4dc4-9cf0-2f2940487576.png)

### Floating Terminal
![terminal](https://user-images.githubusercontent.com/3721204/138015301-97d95ac5-49f3-4d31-9f1e-db15d4e6e9e2.png)
