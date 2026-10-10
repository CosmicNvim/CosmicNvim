local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local indent = 2

-- Options that match Neovim's defaults (filetype plugins, syntax, hlsearch, ...) are left unset.

-- Trailing whitespace is meaningful here: Markdown hard line breaks and diff context lines.
local keep_trailing_whitespace = { markdown = true, diff = true }

local augroup_name = 'CosmicNvimEditor'
local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    local bo = vim.bo[args.buf]
    if keep_trailing_whitespace[bo.filetype] or bo.binary or not bo.modifiable then
      return
    end

    local view = vim.fn.winsaveview()
    local ok, err = pcall(cmd, [[keepjumps keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
    if not ok then
      error(err)
    end
  end,
  group = group,
})

g.mapleader = ' '

-- Cosmic's plugins don't use Neovim's remote-plugin hosts, so skip detecting them.
-- Re-enable one in lua/cosmic/config/editor.lua if a plugin needs it, e.g. `vim.g.loaded_python3_provider = nil`.
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

-- misc
-- defer clipboard provider detection off the startup path, keeping any clipboard set by user config
vim.schedule(function()
  if not vim.api.nvim_get_option_info2('clipboard', {}).was_set then
    vim.o.clipboard = 'unnamedplus'
  end
end)
opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }

-- indention
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent

-- search
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = opt.wildignore + { '*/node_modules/*', '*/.git/*', '*/vendor/*' }

-- ui
opt.cursorline = true
opt.list = true
opt.listchars = {
  tab = '❘-',
  trail = '·',
  lead = '·',
  extends = '»',
  precedes = '«',
  nbsp = '×',
}
opt.mouse = 'a'
opt.number = true
opt.rnu = true
opt.scrolloff = 18
opt.showmode = false
opt.sidescrolloff = 3 -- Lines to scroll horizontally
opt.signcolumn = 'yes'
opt.splitbelow = true -- Open new split below
opt.splitright = true -- Open new split to the right
opt.wrap = false

-- backups
opt.swapfile = false
opt.writebackup = false

-- autocomplete
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.shortmess = opt.shortmess + { c = true }

-- theme
opt.termguicolors = true

-- set border for all windows
opt.winborder = 'rounded'
