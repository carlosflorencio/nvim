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
}
