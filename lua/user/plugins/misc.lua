return {
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {
      keymaps = {
        visual = 'T',
      },
    },
  },

  -- :%S/foo/bar
  -- replace and keep case
  { 'tpope/vim-abolish' },

  {
    -- expand <C-a>/<C-x> toggles increments
    'nat-418/boole.nvim',
    opts = {
      mappings = {
        increment = '<C-a>',
        decrement = '<C-x>',
      },
    },
    event = 'VeryLazy',
  },

  { 'wakatime/vim-wakatime', lazy = false },

  {
    -- peek lines :number, <cr> to jump
    'nacro90/numb.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    -- show colorcolumn when line is too long on insert mode
    'Bekaboo/deadcolumn.nvim',
    event = 'BufReadPost',
    init = function()
      vim.opt.colorcolumn = '80'
    end,
  },

  {
    -- set cwd to git root folder
    'notjedi/nvim-rooter.lua',
    priority = 500,
    enabled = true,
    opts = {},
  },
}
