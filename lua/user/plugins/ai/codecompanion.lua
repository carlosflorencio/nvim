return {
  {
    'olimorris/codecompanion.nvim',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- Optional
      {
        'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
        opts = {},
      },
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = 'openai',
          },
          inline = {
            adapter = 'openai',
          },
          agent = {
            adapter = 'openai',
          },
        },
      }
    end,
  },
}
