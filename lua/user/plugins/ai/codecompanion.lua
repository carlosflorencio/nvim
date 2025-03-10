return {
  {
    'olimorris/codecompanion.nvim',
    enabled = true,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {
        -- tail -f ~/.local/state/nvim/codecompanion.log
        -- log_level = 'DEBUG', -- or "TRACE"
        adapters = {
          -- not working
          -- copilot = function()
          --   return require('codecompanion.adapters').extend('copilot', {
          --     schema = {
          --       model = {
          --         -- claude-3.5-sonnet
          --         -- gpt-4o-2024-08-06
          --         -- o1-2024-12-17
          --         -- o1-mini-2024-09-12
          --         -- gpt4-o
          --         default = 'claude-3.5-sonnet',
          --       },
          --     },
          --   })
          -- end,

          openrouter = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              name = 'openrouter',
              env = {
                url = 'https://openrouter.ai/api',
                api_key = vim.env.OPENROUTER_API_KEY,
              },
              headers = {
                ['X-Title'] = 'Neovim - CodeCompanion',
                ['HTTP-Referer'] = 'https://neovim.io',
              },
              schema = {
                model = {
                  -- google/gemini-flash-1.5
                  -- openai/gpt-4o
                  -- anthropic/claude-3.5-sonnet:beta (self-moderated, faster)
                  default = 'anthropic/claude-3.5-sonnet:beta',
                },
                temperature = {
                  default = 0.5,
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            -- adapter = 'copilot',
            adapter = 'openrouter',
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
        prompt_library = {
          ['Add DocBlock'] = {
            strategy = 'inline',
            description = 'Add a docblock to the selected code',
            opts = {
              -- index = 3,
              -- is_default = true,
              is_slash_cmd = true,
              short_name = 'doc',
              user_prompt = false,
            },
            prompts = {
              {
                role = 'system',
                content = function(context)
                  return string.format(
                    [[ I want you to act as a senior %s developer.
                    Write a docblock for the selected code.
                    If it's typescript, for classes don't add any comments for the constructor, just add comments for the class itself.
                    Return only the code with the docblock.]],
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
                condition = function(context)
                  return context.is_visual
                end,
                content = function(context)
                  local selection = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                  return string.format(
                    [[And this is some code that relates to my question:

```%s
%s
```
]],
                    context.filetype,
                    selection
                  )
                end,
                opts = {
                  contains_code = true,
                  visible = true,
                  tag = 'visual',
                },
              },
            },
          },
          ['Git Diff Code Review'] = {
            strategy = 'chat',
            description = 'Git Diff Code Review',
            opts = {
              is_slash_cmd = true,
              short_name = 'diff_review',
              stop_context_insertion = true,
              auto_submit = true,
            },
            prompts = {
              {
                role = 'user',
                content = function()
                  return string.format(
                    [[I want you to act as a senior developer. Act like you're doing a code review, point out possible mistakes, missed edge cases and suggest improvements. Be short and concise. If the code does not have issues, do not return it. Add the filename and line. Each code block with a suggestion should have a comment inline with the code (inside the code block) explaing the change, this comment should have a prefix of "SUGGESTION:"
         ```diff
         %s
         ```
         ]],
                    vim.fn.system 'git changes'
                  )
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
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
                  local buf_utils = require 'codecompanion.utils.buffers'

                  return '```' .. context.filetype .. '\n' .. buf_utils.get_content(context.bufnr) .. '\n```\n\n'
                end,
                opts = {
                  visible = false,
                  contains_code = true,
                },
              },
              {
                role = 'user',
                content = function(context)
                  local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return string.format(
                    [[And this is some code that relates to my question:

              ```%s
              %s
              ```
              ]],
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
        '<leader>b',
        function()
          -- if package.loaded['zen-mode'] then
          --   require('zen-mode').close()
          -- end

          local input = vim.fn.input 'Ask LLM: '
          if input ~= nil and input ~= '' then
            if input:match '^/%w+$' then
              vim.cmd('CodeCompanion ' .. input)
            else
              if input:sub(1, 2) == 'i ' then
                vim.cmd('CodeCompanion ' .. input:sub(3))
              else
                vim.cmd('CodeCompanionChat ' .. input)
              end
            end
          end
        end,
        desc = 'LLM - Input Prompt',
        mode = { 'v' },
      },
      {
        '<leader>b',
        function()
          vim.cmd 'CodeCompanionChat Toggle'
        end,
        desc = 'LLM - Toggle Chat',
        mode = { 'n' },
      },
      {
        'ga',
        function()
          vim.cmd 'CodeCompanionActions'
        end,
        desc = 'LLM - Actions List',
        mode = { 'v', 'n' },
      },
    },
  },
}
