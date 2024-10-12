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
          diff = {
            -- enabled = false,
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

      -- local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

      -- vim.api.nvim_create_autocmd({ 'User' }, {
      --   pattern = 'CodeCompanionInline*',
      --   group = group,
      --   callback = function(request)
      --     if request.match == 'CodeCompanionInlineFinished' then
      --       -- Format the buffer after the inline request has completed
      --       require('conform').format { bufnr = request.buf }
      --     end
      --   end,
      -- })

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
