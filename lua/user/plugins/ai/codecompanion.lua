return {
  {
    'olimorris/codecompanion.nvim',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = 'copilot',
            roles = {
              llm = 'LLM',
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
          chat = {
            window = {
              opts = {
                number = false,
                relativenumber = false,
              },
            },
            intro_message = 'Welcome ✨! Press ? for options',
            show_settings = false,
          },
        },
      }

      -- vim.api.nvim_create_autocmd('BufEnter', {
      --   pattern = [[\[CodeCompanion\]*]],
      --   callback = function()
      --     -- require('user.util.buffers').debug_buffer(args.buf)
      --   end,
      --   desc = 'Change codecompanion buffer settings',
      -- })
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
            vim.cmd('CodeCompanion ' .. input)
          end
        end,
        desc = 'LLM - Input Prompt',
        mode = { 'n', 'v' },
      },
      {
        '<leader>b',
        function()
          vim.cmd 'CodeCompanionToggle'
        end,
        desc = 'LLM - Toggle Chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>A',
        function()
          vim.cmd 'CodeCompanionActions'
        end,
        desc = 'LLM - Actions List',
        mode = { 'n', 'v' },
      },
    },
  },
}
