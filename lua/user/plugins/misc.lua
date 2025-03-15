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
  {
    'tpope/vim-abolish',
  },

  -- ga motion to align columns (e.g vipga,)
  -- delimiters: <Space>, =, :, ., |, &, #, and ,
  {
    'junegunn/vim-easy-align',
    keys = {
      { 'gA', '<Plug>(EasyAlign)', desc = 'EasyAlign', mode = { 'n', 'x' } },
    },
  },

  {
    -- expand <C-a>/<C-x> toggles increments
    'nat-418/boole.nvim',
    opts = {
      mappings = {},
    },
    event = 'VeryLazy',
    keys = {
      { '<c-a>', '<cmd>Boole increment<CR>', desc = 'Increment', mode = 'n' },
      { '<c-x>', '<cmd>Boole decrement<CR>', desc = 'Decrement', mode = 'n' },
    },
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
