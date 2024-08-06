return {
  {
    {
      'supermaven-inc/supermaven-nvim',
      enabled = false,
      config = function()
        require('supermaven-nvim').setup {
          disable_keymaps = true,
        }
      end,
    },
  },
  {
    'github/copilot.vim',
    enabled = true,
    config = function()
      vim.g.copilot_no_maps = true
      -- issue when expanding a comment inside a docblock
      -- extra * at the beginning of the line are added
    end,
  },
  {
    -- copilot bin outdated
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    enabled = false,
    event = 'InsertEnter',
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<cr>',
          refresh = '<c-r>',
          open = '<M-CR>',
        },
        layout = {
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = '<M-h>',
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
      -- copilot_node_command = 'node', -- Node.js version must be > 16.x
      server_opts_overrides = {},
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    config = function()
      require('CopilotChat').setup {
        debug = false, -- Enable debugging
        show_help = false,
        window = {
          layout = 'float',
          width = 0.8,
          height = 0.8,
        },
        mappings = {
          submit_prompt = {
            normal = '<CR>',
            insert = '<CR>',
          },
          -- cmp integration will be used
          complete = {
            insert = '',
          },
          reset = {
            normal = '<C-l>',
            insert = '<M-l>',
          },
        },
      }

      require('CopilotChat.integrations.cmp').setup()
    end,
    keys = {
      {
        '<leader>aa',
        function()
          if package.loaded['zen-mode'] then
            require('zen-mode').close()
          end

          local input = vim.fn.input 'Ask Copilot: '
          if input ~= nil and input ~= '' then
            require('CopilotChat').ask(input)
          end
        end,
        desc = 'CopilotChat - Quick chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aD',
        '<cmd>CopilotChatFixDiagnostic<cr>',
        desc = 'CopilotChat - Fix Diagnostics',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aA',
        '<cmd>CopilotChatOpen<cr>',
        desc = 'CopilotChat - Open',
        mode = { 'n', 'v' },
      },
      -- Show prompts actions with telescope
      {
        '<leader>ac',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions(), {
            initial_mode = 'normal',
          })
        end,
        desc = 'CopilotChat - Prompt actions',
        mode = { 'n', 'v' },
      },
      {
        '<leader>am',
        '<cmd>CopilotChatCommitStaged<cr>',
        desc = 'CopilotChat - Generate commit message for staged changes',
      },
      {
        '<leader>ad',
        '<cmd>CopilotChatDocs<cr>',
        desc = 'CopilotChat - Generate Docstring',
        mode = { 'v' },
      },
      {
        '<leader>at',
        '<cmd>CopilotChatTests<cr>',
        desc = 'CopilotChat - Generate Tests',
        mode = { 'v', 'n' },
      },
      {
        '<leader>ao',
        '<cmd>CopilotChatOptimize<cr>',
        desc = 'CopilotChat - Optmize the selected code',
        mode = { 'v' },
      },
    },
  },
}
