return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    enabled = true,
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
          accept = '<c-l>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
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
      copilot_node_command = 'node', -- Node.js version must be > 16.x
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
    opts = {
      debug = false, -- Enable debugging
      window = {
        layout = 'float',
      },
      mappings = {
        submit_prompt = {
          normal = '<CR>',
          insert = '<CR>',
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        function()
          vim.ui.input({ prompt = 'Ask Copilot' }, function(input)
            if input ~= nil then
              require('CopilotChat').ask(input)
            end
          end)
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
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
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
    },
  },

  {
    -- using text-davinci-003, more expensive but works better for completions
    'aduros/ai.vim',
    init = function()
      vim.g.ai_no_mappings = 1
    end,
    keys = {
      { '<c-a>', '<cmd>AI<cr>', desc = 'ChatGPT AI Insert', mode = { 'i' } },
    },
  },
}
