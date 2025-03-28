return {
  {
    'github/copilot.vim',
    enabled = true,
    config = function()
      vim.g.copilot_no_maps = true
      -- issue when expanding a comment inside a docblock
      -- extra * at the beginning of the line are added
    end,
    init = function()
      local function get_mise_node_path()
        local handle = io.popen 'mise where node@22'
        if not handle then
          return nil, "Failed to execute 'mise where node@22'"
        end

        local path = handle:read('*a'):match '^%s*(.-)%s*$' -- Read output and trim whitespace
        handle:close()

        if not path or path == '' then
          return nil, 'No path found for node@22'
        end

        return path, nil
      end

      vim.g.copilot_node_command = get_mise_node_path() .. '/bin/node'
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = false,
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    config = function()
      require('CopilotChat').setup {
        debug = false, -- Enable debugging
        show_help = false,
        auto_follow_cursor = false, -- Don't follow the cursor after getting response
        -- window = {
        --   layout = 'float',
        --   width = 0.8,
        --   height = 0.8,
        -- },
        window = {
          layout = 'vertical',
          width = 0.2,
          -- height = 0.8,
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

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.wo.number = false
          vim.wo.relativenumber = false
        end,
      })
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
        '<leader>A',
        function()
          if package.loaded['zen-mode'] then
            require('zen-mode').close()
          end

          local input = vim.fn.input 'Ask Copilot (buffer): '
          if input ~= nil and input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>b',
        function()
          require('CopilotChat').toggle {}
        end,
        desc = 'CopilotChat - Toggle',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aD',
        '<cmd>CopilotChatFixDiagnostic<cr>',
        desc = 'CopilotChat - Fix Diagnostics',
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
}
