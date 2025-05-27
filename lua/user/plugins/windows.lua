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
      ignore = { --			  |windows.ignore|
        buftype = { 'quickfix', 'terminal' },
        filetype = { 'NvimTree', 'neo-tree', 'undotree', 'gundo' },
      },
    },
    keys = {
      { '<leader>sm', '<cmd>WindowsMaximize<cr>', desc = 'Maximize Window' },
    },
    event = 'VeryLazy',
  },
}
