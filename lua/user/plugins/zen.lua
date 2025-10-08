return {
  {
    -- 'folke/zen-mode.nvim',
    -- revert when https://github.com/folke/zen-mode.nvim/pull/180 is merged
    'ouuan/zen-mode.nvim',
    branch = 'border-none',
    cmd = 'ZenMode',
    enabled = true,
    config = function()
      require('zen-mode').setup {
        width = 360,
        plugins = {
          options = {
            enabled = false,
            ruler = true,                 -- disables the ruler text in the cmd line area
            showcmd = true,               -- disables the command in the last line of the screen
          },
          gitsigns = { enabled = false }, -- enables git signs
        },
        on_close = function()
          -- vim.o.cmdheight = 0
          -- vim.cmd "set cc=80"
        end,
        on_open = function()
          -- vim.o.cmdheight = 1
          -- vim.cmd "set cc="
        end,
      }
    end,
    keys = {
      { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
      { '<leader>e',  '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
      -- { '<leader>sm', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
    },
  },
}
