# ✨ CosmicNvim ✨

Welcome! CosmicNvim is a lightweight and opinionated Neovim config for web development, specifically designed to provide a  ✨ COSMIC  ✨ programming experience!

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
- Easy LSP installation with [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)
- Autocompletion provided by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- Session management with [auto-session](https://github.com/rmagatti/auto-session)
- Additional custom highlighting
- Floating windows for references, renaming, diagnostics, code actions and more!

_While CosmicNvim is geared specifically toward TypeScript/JavaScript development, it should be able to provide a great experience with any LSP supported language._

### How to install

_Runs best on Neovim (>=0.6.0) but requires (>=0.5.1)_

Using [stow](https://www.gnu.org/software/stow/)

```
  $ git clone git@github.com:mattleong/CosmicNvim.git
  $ mkdir ~/.config/nvim
  $ stow -t ~/.config/nvim CosmicNvim
```

Symlinking (don't use relative pathing)

```
  $ cd ~/
  $ git clone git@github.com:mattleong/CosmicNvim.git
  $ ln -s ~/.config/nvim ~/CosmicNvim
```

Just clone it
```
  $ cd ~/.config
  $ git clone git@github.com:mattleong/CosmicNvim.git nvim
```

#### First run

You will need to set up Packers compiled file via the steps below:

1. Start NVIM
2. Run `PackerUpdate` & `PackerCompile`
3. Restart NVIM
4. Install LSP servers, `:LspInstallInfo` or `:LspInstall tsserver`

_Install script coming soon..._

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
