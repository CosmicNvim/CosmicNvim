# CosmicNvim Agent Instructions

This is a Neovim configuration written in Lua, using lazy.nvim for plugin management.

## Build/Lint/Test Commands

### Linting & Formatting

```bash
# Format all Lua files with stylua
stylua .

# Check Lua syntax (dry-run, don't modify)
stylua --check .

# Format a specific file
stylua lua/cosmic/core/init.lua

# Lint markdown files
markdownlint *.md
```

### Testing

This project has no automated test suite. Testing is done by:
1. Opening Neovim: `nvim`
2. Checking for Lua syntax errors on startup
3. Verifying plugin functionality manually

### Validation

```bash
# Validate Lua syntax without running
lua -c lua/cosmic/core/init.lua

# Or use Neovim's built-in Lua parser
nvim --headless -c "luafile lua/cosmic/core/init.lua" -c "q"
```

## Code Style Guidelines

### Formatting

- **Indentation**: 2 spaces (no tabs)
- **Line endings**: Unix (LF)
- **Quote style**: Single quotes preferred
- **Line length**: No strict limit, but keep reasonable
- **Formatter**: Use stylua (configured in `.stylua.toml`)

### Naming Conventions

- **Modules**: lowercase with underscores (e.g., `mappings.lua`, `cosmic.lua`)
- **Variables**: `snake_case` for locals, descriptive names
- **Constants**: UPPER_CASE for true constants
- **Functions**: `snake_case`, descriptive verbs (e.g., `set_keymap`, `on_attach`)
- **Plugin specs**: Return tables with lazy.nvim spec format

### Module Structure

```lua
-- Standard module pattern
local M = {}

-- Local requires at top
local utils = require('cosmic.utils')

-- Private functions (optional)
local function helper() end

-- Public functions
function M.public_function()
  -- implementation
end

return M
```

### Imports

```lua
-- Group standard library requires first
local vim = vim

-- Then Cosmic modules
local utils = require('cosmic.utils')
local user_config = require('cosmic.core.user')

-- Then external/plugin modules
local lspconfig = require('lspconfig')
```

### Error Handling

Always use `pcall` for requiring modules that might fail:

```lua
local ok, err = pcall(require, 'some.module')
if not ok then
  error(('Error loading %s...\n\n%s'):format(module_name, err))
end
```

For LSP and plugin configs, handle missing user config gracefully:

```lua
local ok, user_config = pcall(require, 'cosmic.config.config')
if not ok then
  user_config = {}
end
```

### Keymaps

Use the utility function for consistent keymaps:

```lua
local map = require('cosmic.utils').set_keymap

map('n', '<leader>xx', ':SomeCommand<cr>', { desc = 'Description' })
```

### Plugin Configuration (lazy.nvim)

```lua
return {
  'author/plugin-name',
  dependencies = {
    'dep1',
    { 'dep2', lazy = true },
  },
  event = 'BufReadPre',
  config = function()
    require('plugin').setup({
      -- config
    })
  end,
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'plugin-name'),
}
```

### LSP Server Configuration

```lua
local defaults = require('cosmic.lsp.servers.defaults')

return {
  on_attach = function(client, bufnr)
    defaults.on_attach(client, bufnr)
    -- server-specific on_attach
  end,
  capabilities = defaults.capabilities,
  settings = {
    -- server-specific settings
  },
}
```

### Type Annotations

Use LuaCATS annotations when applicable:

```lua
---@diagnostic disable: missing-fields
---@type vim.lsp.ClientConfig
local M = {}

---@param client vim.lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
  -- ...
end
```

### Configuration Tables

Structure config tables with clear defaults and user override support:

```lua
local defaults = {
  option = true,
  nested = {
    value = 42,
  },
}

local config = vim.tbl_deep_extend('force', defaults, user_config or {})
```

### Comments

- Use `--` for single-line comments
- Use `--[[ ]]` for multi-line comments
- Add brief descriptions for public functions
- Comment complex logic or workarounds

### General Best Practices

- Prefer `vim.api.nvim_*` functions over `vim.cmd` when possible
- Use `vim.tbl_deep_extend('force', ...)` for merging config tables
- Check for feature support before using (e.g., `client:supports_method()`)
- Use autocmds with named augroups for cleanup
- Keep plugin configs modular (one file per plugin in `lua/cosmic/plugins/`)
- User overrides go in `lua/cosmic/config/` (gitignored, user-created)

## Project Structure

```
.
├── init.lua                 # Entry point
├── lua/cosmic/
│   ├── init.lua            # Core loader
│   ├── core/               # Core functionality
│   │   ├── commands.lua    # User commands
│   │   ├── editor.lua      # Editor settings
│   │   ├── mappings.lua    # Key mappings
│   │   ├── pluginsInit.lua # Plugin setup
│   │   └── user.lua        # User config loader
│   ├── config/             # User configuration (examples/)
│   ├── lsp/                # LSP configuration
│   │   ├── servers/        # Per-server configs
│   │   └── diagnostics.lua # Diagnostic settings
│   ├── plugins/            # Plugin specs (lazy.nvim)
│   └── utils/              # Utility functions
├── .stylua.toml            # Lua formatter config
└── .markdownlint.yaml      # Markdown linter config
```

## External Tools

- **stylua**: Lua formatter (required for contributions)
- **markdownlint**: Markdown linter
- **Neovim 0.11+**: Required version
