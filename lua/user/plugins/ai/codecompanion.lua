return {
  {
    'olimorris/codecompanion.nvim',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'codecompanion' },
        },
        ft = { 'codecompanion' },
      },
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = 'copilot',
            roles = {
              llm = 'LLM', -- markdown header
            },
          },
          inline = {
            adapter = 'copilot',
          },
          agent = {
            adapter = 'copilot',
          },
        },
        display = {
          diff = {
            -- provider = 'mini_diff',
            enabled = false,
          },
          chat = {
            window = {
              opts = {
                number = false,
                relativenumber = false,
              },
            },
            intro_message = 'Welcome, press ? for options',
            show_settings = false,
          },
        },
      }
    end,
    keys = {
      {
        '<leader>a',
        function()
          -- if package.loaded['zen-mode'] then
          --   require('zen-mode').close()
          -- end

          local input = vim.fn.input 'Ask LLM: '
          if input ~= nil and input ~= '' then
            vim.cmd('CodeCompanionChat ' .. input)
          end
        end,
        desc = 'LLM - Input Prompt',
        mode = { 'n', 'v' },
      },
      {
        '<leader>b',
        function()
          vim.cmd 'CodeCompanionChat Toggle'
        end,
        desc = 'LLM - Toggle Chat',
        mode = { 'n', 'v' },
      },
      {
        '<c-a>',
        function()
          vim.cmd 'CodeCompanionActions'
        end,
        desc = 'LLM - Actions List',
        mode = { 'v' },
      },
      {
        '<leader>A',
        function()
          vim.cmd 'CodeCompanionActions'
        end,
        desc = 'LLM - Actions List',
        mode = { 'n' },
      },
    },
  },
}
