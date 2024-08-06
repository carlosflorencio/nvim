return {
  {
    'alexghergh/nvim-tmux-navigation',
    enabled = true,
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        -- disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
      -- vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      -- vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  {
    'RyanMillerC/better-vim-tmux-resizer',
    lazy = true,
    init = function()
      vim.g.tmux_resizer_no_mappings = 1
    end,
    keys = {
      { '<m-H>', ':TmuxResizeLeft<CR>', desc = 'Resize left' },
      { '<m-J>', ':TmuxResizeDown<CR>', desc = 'Resize down' },
      { '<m-K>', ':TmuxResizeUp<CR>', desc = 'Resize up' },
      { '<m-L>', ':TmuxResizeRight<CR>', desc = 'Resize right' },
    },
  },
}
