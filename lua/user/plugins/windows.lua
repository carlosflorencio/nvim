return {

  {
    -- expand windows
    'anuvyklack/windows.nvim',
    enabled = true,
    dependencies = {
      'anuvyklack/middleclass',
      -- "anuvyklack/animation.nvim"
    },
    opts = {
      autowidth = {
        -- winwidth = 30,
      },
    },
    keys = {
      { '<leader>sm', '<cmd>WindowsMaximize<cr>', desc = 'Maximize Window' },
    },
    event = 'VeryLazy',
  },
}
