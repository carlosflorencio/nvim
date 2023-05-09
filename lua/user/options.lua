vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.iskeyword:append "-" -- consider string-string as whole word
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.ignorecase = true -- Ignore case
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.colorcolumn = "80"
vim.opt.updatetime = 100 -- Save swap file and trigger CursorHold
vim.opt.timeoutlen = 600 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.shell = "/bin/sh" -- fish is slow
vim.opt.laststatus = 3 -- Only one statusline (avoid nvim-tree duplicated statusline)
vim.opt.syntax = "off" -- Disable regex syntax highlighting, using Treesitter

-- folds ufo
vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.mouse = "a" -- Enable mouse mode
vim.o.clipboard = "unnamedplus" -- Enable mouse mode
vim.o.undofile = true -- Save undo history
vim.o.breakindent = true
vim.o.showtabline = 2

if vim.g.started_by_firenvim == true then
  vim.o.laststatus = 0
  vim.o.showtabline = 1
  vim.opt.wrap = true
end
