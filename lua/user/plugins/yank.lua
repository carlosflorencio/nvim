return {
  {
    -- yank ring
    'gbprod/yanky.nvim',
    opts = {
      ring = {
        history_length = 50,
        storage = 'shada',
        sync_with_numbered_registers = true,
        cancel_event = 'update',
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 100,
      },
      system_clipboard = {
        sync_with_ring = true,
      },
      preserve_cursor_position = {
        enabled = true,
      },
      textobj = {
        enabled = true,
      },
    },
    keys = {
      {
        'p',
        '<Plug>(YankyPutAfter)',
        desc = 'Yanky put after',
        mode = { 'n', 'x' },
      },
      {
        'P',
        '<Plug>(YankyPutBefore)',
        desc = 'Yanky put before',
        mode = { 'n', 'x' },
      },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' } },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' } },
      { ']y', '<Plug>(YankyNextEntry)', mode = 'n' },
      { '[y', '<Plug>(YankyPreviousEntry)', mode = 'n' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', mode = 'n' },
      { '<c-n>', '<Plug>(YankyNextEntry)', mode = 'n' },
      -- { "<c-v>", "<esc><cmd>Telescope yank_history initial_mode=normal<cr>", mode = { "n", "i", "v" } },
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' } }, -- prevent going up when yanking
      {
        '<leader>lp', -- jump to last put
        function()
          require('yanky.textobj').last_put()
        end,
      },
    },
  },
}
