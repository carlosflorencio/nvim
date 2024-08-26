return {
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup {
        resize_mode = {
          hooks = {
            on_leave = function()
              vim.cmd [[WindowsEnableAutowidth]]
            end,
            on_enter = function()
              vim.cmd [[WindowsDisableAutowidth]]
            end,
          },
        },
      }

      -- resize
      vim.keymap.set('n', '<m-H>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<m-J>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<m-K>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<m-L>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      -- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
    end,
  },
}
