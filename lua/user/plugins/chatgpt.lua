return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      window = {
        layout = "float",
        -- relative = "cursor",
        -- width = 1,
        -- height = 0.4,
        -- row = 1,
      },
      -- See Configuration section for rest
    },
    keys = {
      {
        "<leader>aa",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>cch",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
        mode = { "n", "v" },
      },
      -- Show prompts actions with telescope
      {
        "<leader>ccp",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
        mode = { "n", "v" },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim" },
    },
    cmd = "Chat",
    keys = {
      { "<leader>at", "<cmd>Chat tests<cr>", desc = "ChatGPT Generate Tests", mode = { "v", "x" } },
    },
  },

  {
    -- slow prompt, does not stream the response :(
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup {
        chat = {
          keymaps = {
            close = { "<C-q>" },
          },
        },
        edit_with_instructions = {
          diff = true,
          keymaps = {
            close = { "<C-q>" },
          },
        },
        popup_layout = {
          default = "center",
        },
        popup_input = {
          submit = "<Enter>",
          submit_n = "<Enter>",
        },
        openai_params = {
          model = "gpt-4-0125-preview",
          -- max_tokens = 300,
        },
        openai_edit_params = {
          model = "gpt-4-0125-preview",
        },
        actions_paths = {
          vim.fn.stdpath "config" .. "/chatgpt/actions.json",
        },
        show_quickfixes_cmd = "quickfix",
      }
    end,
    keys = {
      -- { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "ChatGPT Prompt" },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", desc = "ChatGPT Generate Doc Comment", mode = { "v", "x" } },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<cr>", desc = "ChatGPT Optmize code", mode = { "v", "x" } },
      -- { "<leader>at", "<cmd>ChatGPTRun tests<cr>", desc = "ChatGPT Generate Tests", mode = { "v", "x" } }, -- custom action
      { "<leader>aa", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "ChatGPT Edit with Instructions", mode = "v" },
      {
        "<leader>ar",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        desc = "ChatGPT Readibility Analysis",
        mode = "v",
      },
      -- { "<leader>ar", "<cmd>ChatGPTRun<tab>", desc = "ChatGPT Run Mode", mode = "v" },
    },
  },

  {
    -- using text-davinci-003, more expensive but works better for completions
    "aduros/ai.vim",
    init = function()
      vim.g.ai_no_mappings = 1
    end,
    keys = {
      { "<c-a>", "<cmd>AI<cr>", desc = "ChatGPT AI Insert", mode = { "i" } },
    },
  },

  {
    -- use chatgpt on lsp diagnostics
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    init = function()
      -- vim.g["wtf_hooks"] = {
      --   request_started = function()
      --     vim.cmd "hi StatusLine ctermbg=NONE ctermfg=yellow"
      --   end,
      --   request_finished = vim.schedule_wrap(function()
      --     vim.cmd "hi StatusLine ctermbg=NONE ctermfg=NONE"
      --   end),
      -- }
    end,
    -- event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>ae",
        mode = { "n" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        "<leader>aE",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    },
  },
}
