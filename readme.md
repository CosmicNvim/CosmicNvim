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
- Enhanced syntax highlighting via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Dashboard via [dashboard-nvim](https://github.com/glepnir/dashboard-nvim)
- Hand-built statusline via [galaxyline](https://github.com/CosmicNvim/galaxyline.nvim)
- Explore files via [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- Fuzzy finder via [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- Floating terminal with [vim-floaterm](https://github.com/voldikss/vim-floaterm)
- Auto LSP installation via [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)
- Autocompletion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Additional TypeScript support via [nvim-lsp-ts-utils](https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils)
- Snippet support via [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- Session management via [auto-session](https://github.com/rmagatti/auto-session)
- Notifications via [nvim-notify](https://github.com/rcarriga/nvim-notify)
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
  nvim +CosmicReloadSync
```

Additional CosmicNvim installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installation).

Additional LSP server installation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Installing-LSP-servers).

CosmicNvim uninstallation [details](https://github.com/CosmicNvim/CosmicNvim/wiki/Uninstalling-CosmicNvim).

## 🎨 Theming

CosmicNvim comes with first-class support for the following themes:

- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [Dracula](https://github.com/Mofiqul/dracula.nvim)
- [Enfocado](https://github.com/wuelnerdotexe/vim-enfocado)
- [Github](https://github.com/projekt0n/github-nvim-theme)
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim)
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [Monokai](https://github.com/tanvirtin/monokai.nvim)
- [Nightfox](https://github.com/EdenEast/nightfox.nvim)
- [Nord](https://github.com/shaunsingh/nord.nvim)
- [Onedark](https://github.com/navarasu/onedark.nvim)
- [Rose-pine](https://github.com/rose-pine/neovim)
- [Tokyonight](https://github.com/folke/tokyonight.nvim)

[Additional Screenshots](https://github.com/CosmicNvim/CosmicNvim/wiki/Theme-Screenshots)

## ⚙️ Configuration

[General Info](./lua/cosmic/config/examples/readme.md)

[Cosmic configurations](./lua/cosmic/config/examples/config.lua)

[Add additional vim options](./lua/cosmic/config/examples/editor.lua)

## ✨ Cosmic Commands

### Update CosmicNvim

```vimcommand
:CosmicUpdate
```

By default, this will assume the Cosmic git directory is placed at `vim.fn.stdpath('config')`, i.e. `~/.config/nvim`.
Otherwise, you may define the shell environment variable `COSMICNVIM_INSTALL_DIR`.

### Clear cache and sync plugins

```vimcommand
:CosmicReloadSync
```

Useful for testing themes or plugins on the fly!

### Reload user config

```vimcommand
:CosmicReload
```

Useful for non-plugin related changes such as editor settings or mappings.

## 🗺 Default Mappings

[File navigation](./lua/cosmic/plugins/telescope/mappings.lua)

[File explorer](./lua/cosmic/plugins/nvim-tree/mappings.lua)

[Terminal](./lua/cosmic/plugins/terminal/mappings.lua)

[LSP](./lua/cosmic/lsp/mappings.lua)

[Other](./lua/cosmic/mappings.lua)

## 📷 Screenshots

### Statusline

<!--
<img width="1762" alt="normal" src="https://user-images.githubusercontent.com/3721204/140678741-266dc883-e1bb-4729-827e-1195acd62762.png">
<img width="1762" alt="insert" src="https://user-images.githubusercontent.com/3721204/140678744-a89b7413-383d-4d81-affd-03c3815644bc.png">
<img width="1762" alt="visual" src="https://user-images.githubusercontent.com/3721204/140678746-3ac4396d-32f9-4988-a296-76857291baca.png">
<img width="1774" alt="replace" src="https://user-images.githubusercontent.com/3721204/140678745-a1cb5200-f945-4cff-ae0c-2285b25f333f.png">
-->

<img width="1259" alt="Screen Shot 2021-12-19 at 1 21 21 PM" src="https://user-images.githubusercontent.com/3721204/146691276-cb9bebe3-ad60-4314-aeef-bd5848dc594f.png">
<img width="1260" alt="Screen Shot 2021-12-19 at 1 21 35 PM" src="https://user-images.githubusercontent.com/3721204/146691275-53b3c18a-f71d-4512-8f69-29e36cd6e587.png">
<img width="1262" alt="Screen Shot 2021-12-19 at 1 22 01 PM" src="https://user-images.githubusercontent.com/3721204/146691274-e273ea5f-09ed-4507-9bbe-3ffb833e963f.png">
<img width="1256" alt="Screen Shot 2021-12-19 at 1 22 18 PM" src="https://user-images.githubusercontent.com/3721204/146691273-1479bc96-4c32-478b-adf6-95ae2b68d4a8.png">

### Autocomplete

<img width="1792" alt="autocomplete" src="https://user-images.githubusercontent.com/3721204/140592713-f08c72f8-4fc5-4422-8987-2224b9425725.png">

### Rename

<img width="498" alt="Screen Shot 2021-12-10 at 4 22 28 PM" src="https://user-images.githubusercontent.com/3721204/145656501-e1aec4be-c8bc-4e59-8c2f-2d99d50bbea2.png">

### Rename change notification

<img width="1792" alt="rename notification" src="https://user-images.githubusercontent.com/3721204/140592788-27c0f02a-e31b-4af7-8f0c-a49a988e295e.png">

### Code Actions

<img width="613" alt="Screen Shot 2021-12-10 at 3 37 38 PM" src="https://user-images.githubusercontent.com/3721204/145654798-84c88a69-414e-457b-b595-e76b767ea5d3.png">

### Hover

<img width="1792" alt="hover" src="https://user-images.githubusercontent.com/3721204/140592798-b9dbbdee-8496-4998-a874-110a051a7672.png">

[See more screenshots](https://github.com/CosmicNvim/CosmicNvim/wiki/Screenshots)
