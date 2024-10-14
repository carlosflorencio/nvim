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
        prompt_library = {
          ['Review'] = {
            strategy = 'chat',
            description = 'Review the selected code',
            opts = {
              -- index = 3,
              -- is_default = true,
              modes = { 'v' },
              is_slash_cmd = true,
              short_name = 'review',
              stop_context_insertion = true, -- selected text is already sent
              user_prompt = false, -- user input is not required
              auto_submit = true,
            },
            prompts = {
              {
                role = 'system',
                content = function(context)
                  return string.format(
                    [[I want you to act as a senior %s developer. Act like you're doing a code review, point out possible mistakes, missed edge cases and suggest improvements. Don't return the whole modified code, only return the parts of the code you have suggestions. Don't send the whole modified code! Each code block with a suggestion should have a comment inline with the code (inside the code block) explaing the change, this comment should have a prefix of "SUGGESTION:".]],
                    context.filetype
                  )
                end,
                opts = {
                  visible = false,
                  tag = 'system_tag',
                },
              },
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return string.format(
                    [[Review this code from buffer %d:

              ```%s
              %s
              ```
              ]],
                    context.bufnr,
                    context.filetype,
                    code
                  )
                end,
                opts = {
                  visible = false,
                  contains_code = true,
                },
              },
            },
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
