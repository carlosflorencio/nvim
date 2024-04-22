return {
  {
    -- debug print variables
    'andrewferrier/debugprint.nvim',
    dependencies = {
      'echasnovski/mini.nvim', -- Needed to enable :ToggleCommentDebugPrints for NeoVim <= 0.9
      'nvim-treesitter/nvim-treesitter', -- Needed to enable treesitter for NeoVim 0.8
    },
    version = '*',
    opts = {
      move_to_debugline = true,
      print_tag = 'here',
      keymaps = {
        normal = {
          plain_below = '<leader>dd',
        },
      },
    },
  },
}
