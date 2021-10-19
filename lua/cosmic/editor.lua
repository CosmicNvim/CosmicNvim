local cmd = vim.cmd
local opt = vim.opt
local indent = 2

cmd([[
	filetype plugin indent on
	autocmd BufWritePre * :%s/\s\+$//e
]])

-- misc
opt.syntax = 'enable'
opt.hidden = true
opt.encoding = 'utf-8'
opt.clipboard = 'unnamedplus'
opt.backspace = { 'eol', 'start', 'indent' }
opt.matchpairs = { '(:)', '{:}', '[:]', '<:>' }

-- indention
opt.autoindent = true
opt.smartindent = true

-- tabs
opt.tabstop = indent
opt.softtabstop = indent
opt.shiftwidth = indent
opt.expandtab = true

-- search
opt.wildmenu = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = opt.wildignore + { '*/node_modules/*', '*/wp-includes/*', '*/wp-admin/*', '*/vendor/*' }
opt.hlsearch = false

-- ui
opt.number = true
opt.rnu = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.laststatus = 2
opt.wrap = false
opt.scrolloff = 18
opt.sidescrolloff = 3 -- Lines to scroll horizontally
opt.list = true
opt.listchars = {
  tab = '❘-',
  trail = '·',
  lead = '·',
  extends = '»',
  precedes = '«',
  nbsp = '×',
}
opt.showmode = false
opt.lazyredraw = true
opt.mouse = 'a'
opt.splitright = true -- Open new split to the right
opt.splitbelow = true -- Open new split below

-- backups
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- autocomplete
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.shortmess = opt.shortmess + { c = true }

-- perfomance
opt.updatetime = 100
opt.timeoutlen = 400
opt.redrawtime = 1500
opt.ttimeoutlen = 10

-- theme
opt.termguicolors = true
