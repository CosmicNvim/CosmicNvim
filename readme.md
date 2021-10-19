# ✨ CosmicNvim ✨

A lightweight and opinionated Neovim configuration for web development specifically designed to provide a COSMIC programming experience!

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
- Floating terminal with [vim-floatterm](https://github.com/voldikss/vim-floaterm)
- Easy LSP installation with [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)
- Autocompletion provided by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Session management with [auto-session](https://github.com/rmagatti/auto-session)
- Floating windows for references, renaming, diagnostics, code actions and more!

_While CosmicNvim is geared specifically toward TypeScript/JavaScript development, it should be able to provide a great experience with any LSP supported language._

### How to install

Using [stow](https://www.gnu.org/software/stow/)

```
  $ git clone git@github.com:mattleong/CosmicNvim.git
  $ mkdir ~/.config/nvim
  $ stow -t ~/.config/nvim CosmicNvim
```

Symlinking (don't use relative pathing)

```
  $ git clone git@github.com:mattleong/CosmicNvim.git
  $ ln -s ~/.config/nvim ~/CosmicNvim
```

## Screenshots 📷

### Statusline
![insert](https://user-images.githubusercontent.com/3721204/137990345-d036c2d1-0f9e-4d4e-bd6c-13e051609f61.png)
![normal](https://user-images.githubusercontent.com/3721204/137990346-8f614b6b-63da-471a-b5be-635b587f10a1.png)
![replace](https://user-images.githubusercontent.com/3721204/137990347-b59428d6-b5fe-4edb-8ceb-ab37b69b7e76.png)
![visual](https://user-images.githubusercontent.com/3721204/137990348-6eb29e9b-e912-4d6e-8a5e-e763816613d7.png)

### Autocomplete
![autocomplete](https://user-images.githubusercontent.com/3721204/137990341-39251a51-7fb8-47cc-a92e-b3893ef6cb34.png)

### Rename
![rename](https://user-images.githubusercontent.com/3721204/137995308-b8260fe6-a2e8-427d-aa21-5df0bfecf72f.png)

### Hover
![lsp hover3](https://user-images.githubusercontent.com/3721204/137989460-91b094d5-e47e-4775-a252-39442cf398d9.png)

### Find Reference
![lsp ref](https://user-images.githubusercontent.com/3721204/137989929-12036575-4b63-471e-ab44-ac6ad31bb478.png)

### File Navigation
![telescope](https://user-images.githubusercontent.com/3721204/137989935-30f3bf57-435e-4e5c-8817-2d8c6c6dd9b1.png)

### Floating Terminal
![terminal](https://user-images.githubusercontent.com/3721204/137989938-70a72dca-c6e6-4bb2-91fe-89ed94614824.png)
