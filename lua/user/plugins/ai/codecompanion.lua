return {
  {
    'echasnovski/mini.diff',
    lazy = false,
    config = function()
      local diff = require 'mini.diff'
      diff.setup {
        -- Disabled by default
        source = diff.gen_source.none(),
      }

      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        group = vim.api.nvim_create_augroup('carlos/minidiff', { clear = true }),
        pattern = '*',
        callback = function()
          -- improve diff color on dark themes
          -- makes it green
          vim.api.nvim_set_hl(0, 'MiniDiffOverChange', { link = 'DiffAdd' })
        end,
      })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    enabled = true,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    init = function()
      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
    config = function()
      local function openrouter_adapter(model)
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
              default = model,
            },
            temperature = {
              default = 0.3,
            },
          },
        })
      end

      require('codecompanion').setup {
        -- tail -f ~/.local/state/nvim/codecompanion.log
        -- log_level = 'DEBUG', -- or "TRACE"
        adapters = {
          gemini = openrouter_adapter 'google/gemini-2.5-pro-preview',
          flash = openrouter_adapter 'google/gemini-2.5-flash-preview-05-20',
          ['4.1'] = openrouter_adapter 'openai/gpt-4.1',
          ['4'] = openrouter_adapter 'anthropic/claude-sonnet-4',
        },
        strategies = {
          chat = {
            adapter = '4',
            roles = {
              llm = function(adapter)
                return adapter.schema.model.default
              end,
            },
          },
          inline = {
            adapter = 'copilot',
          },
          agent = {
            adapter = '4',
          },
        },
        display = {
          diff = {
            provider = 'mini_diff',
          },
          chat = {
            window = {
              opts = {
                number = false,
                relativenumber = false,
              },
            },
            intro_message = 'Welcome, press ? for options or gd to debug.',
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
            -- /command
            if input:match '^/%w+$' then
              vim.cmd('CodeCompanion ' .. input)
            else
              -- inline assistant mode
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
        '<c-a>',
        function()
          local input = vim.fn.input 'Inline LLM: '
          if input ~= nil and input ~= '' then
            vim.cmd('CodeCompanion ' .. input)
          end
        end,
        desc = 'LLM - Input Prompt',
        mode = { 'i' },
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
