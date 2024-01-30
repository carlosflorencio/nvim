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

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { { 'prettierd', 'prettier' } },
      },
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {},
  },

   {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  require("user.lsp"),

  { import = 'user.plugins' },
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = {},
    -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  }
end, 0)

-- Options
vim.opt.wrap = false -- prevent line wrap on long lines
vim.opt.scrolloff = 10
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.ignorecase = true -- Ignore case in searches / ?
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.colorcolumn = '80' -- guideline at 80 characters
vim.opt.completeopt = 'menu,menuone,noselect' -- command line completion options
vim.opt.signcolumn = 'yes' -- Always show the sign column, otherwise it would shift the text each time
vim.opt.fillchars = { eob = '~' }
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.shell = '/bin/sh' -- fish is slow
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.clipboard = 'unnamedplus' -- system clipboard
vim.o.undofile = true -- Save undo history
vim.o.breakindent = true -- Indent wrapped lines
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300


local function augroup(name)
  return vim.api.nvim_create_augroup('user_' .. name, {
    clear = true,
  })
end

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
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
