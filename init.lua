-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- disable netrw, we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Options
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.wrap = false -- prevent line wrap on long lines
vim.opt.scrolloff = 10
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.completeopt = 'menu,menuone,noselect' -- completion options
vim.opt.signcolumn = 'yes' -- Always show the sign column, otherwise it would shift the text each time
vim.opt.fillchars = { eob = '~' }
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
-- vim.opt.shell = '/bin/sh' -- fish is slow
vim.opt.shell = '/opt/homebrew/bin/fish' -- fish is slow
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.clipboard = 'unnamedplus' -- system clipboard
vim.o.undofile = true -- Save undo history
vim.o.breakindent = true -- Indent wrapped lines
vim.opt.showmode = false -- don't show mode since we use a statusline
vim.opt.jumpoptions = 'stack,view' -- jump back c-o preserves y cursor position
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time (whick-key appears sooner)
vim.opt.list = true -- differentiate white spaces
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.hlsearch = true -- highlight search (esc keymap to hide)

vim.opt.winborder = 'single' -- Set window border style

-- disable vim configuration options inside files
vim.opt.modeline = false

-- sync buffers automatically
vim.opt.autoread = true
-- disable neovim generating a swapfile and showing the error
vim.opt.swapfile = false

-- folds
-- za toggle fold, zo open fold, zc close fold
-- zM close all folds, zR open all folds
-- zx close all but current
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr' -- Use Treesitter for folding
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Auto formating options (o in a docblock adds * prefix)
-- vim.opt.formatoptions = 'jrcqlo'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Global variables
vim.g.personal_notes = '~/Projects/notes'

-- better diff options
-- https://www.reddit.com/r/neovim/comments/1ihpvaf/the_linematch_diffopt_makes_builtin_diff_so_sweat/
vim.o.diffopt = 'algorithm:histogram,internal,filler,closeoff,linematch:60,followwrap'

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nmac427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {
        auto_cmd = true,
      }

      -- Automatically detect indent settings
      -- had to change this because https://github.com/NMAC427/guess-indent.nvim/issues/3#issuecomment-1613353299
      -- vim.cmd [[
      --             augroup GuessIndent
      --               autocmd!
      --               autocmd FileType * lua require("guess-indent").set_from_buffer("auto_cmd")
      --               " Run once when saving for new files
      --               autocmd BufNewFile * autocmd BufWritePost <buffer=abuf> ++once silent lua require("guess-indent").set_from_buffer("auto_cmd")
      --             augroup END
      --           ]]
    end,
  }, -- :GuessIndent Detect tabstop and shiftwidth automatically
  -- { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  -- alternative https://github.com/pteroctopus/faster.nvim
  { 'LunarVim/bigfile.nvim', opts = {} },
  { import = 'user.plugins' },
  { import = 'user.plugins.ai' },
}, {
  ui = { border = 'rounded' },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
})

require 'user.autocmds'
require 'user.cmds'
require 'user.keymaps'
require 'user.keymaps-lsp'
require 'user.filetypes'

vim.cmd [[colorscheme moonfly]]
