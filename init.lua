-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw, we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- set term gui colors (most terminals support this)

-- Install package manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- theme
  {
    "navarasu/onedark.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup {
        style = "darker",
        ending_tildes = true,
        code_style = {
          comments = "none",
        },
      }
      require("onedark").load()
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        globalstatus = true,
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  "nmac427/guess-indent.nvim",

  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
      pre_hook = function(...)
        local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if loaded and ts_comment then
          return ts_comment.create_pre_hook()(...)
        end
      end,
    },
    keys = {
      { "gc",        mode = { "n", "v" } },
      { "gb",        mode = { "n", "v" } },
      { "<leader>/", "<Plug>(comment_toggle_linewise_visual)",  desc = "Comment toggle linewise (visual)", mode = "v" },
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
    },
    event = "User FileOpened",
  },

  require("user.lsp"),

  { import = "user.plugins" }

})

-- Options
vim.opt.wrap = false                          -- prevent line wrap on long lines
vim.opt.scrolloff = 10
vim.opt.relativenumber = true                 -- Relative line numbers
vim.opt.cursorline = true                     -- Enable highlighting of the current line
vim.opt.expandtab = true                      -- Use spaces instead of tabs
vim.opt.ignorecase = true                     -- Ignore case in searches / ?
vim.opt.splitbelow = true                     -- Put new windows below current
vim.opt.splitright = true                     -- Put new windows right of current
vim.opt.colorcolumn = "80"                    -- guideline at 80 characters
vim.opt.completeopt = "menu,menuone,noselect" -- command line completion options
vim.opt.signcolumn = "yes"                    -- Always show the sign column, otherwise it would shift the text each time
vim.opt.fillchars = { eob = "~" }
vim.opt.pumheight = 10                        -- Maximum number of entries in a popup
vim.opt.shell = "/bin/sh"                     -- fish is slow
vim.o.mouse = "a"                             -- Enable mouse mode
vim.o.clipboard = "unnamedplus"               -- system clipboard
vim.o.undofile = true                         -- Save undo history
vim.o.breakindent = true                      -- Indent wrapped lines

require("user.keymaps")
