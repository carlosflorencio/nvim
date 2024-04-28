return {
  {
    -- debug print variables
    'andrewferrier/debugprint.nvim',
    event = 'VeryLazy',
    cmd = { 'ToggleCommentDebugPrints', 'DeleteDebugPrints' },
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
          plain_below = '<leader>dl',
          plain_above = 'g?P',
          variable_below = '<leader>dd',
          variable_above = 'g?V',
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = 'g?o',
          textobj_above = 'g?O',
          toggle_comment_debug_prints = nil,
          delete_debug_prints = nil,
        },
        visual = {
          variable_below = '<leader>dd',
          variable_above = 'g?V',
        },
      },
      commands = {
        toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
        delete_debug_prints = 'DeleteDebugPrints',
      },
    },
  },
}
