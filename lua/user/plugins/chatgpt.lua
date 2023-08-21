return {
  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim" },
    },
    cmd = "Chat",
    keys = {
      { "<leader>at", "<cmd>Chat tests<cr>", desc = "ChatGPT Generate Tests", mode = "v" },
      { "<leader>ad", "<cmd>ChatGPTRun doc<cr>", desc = "ChatGPT Generate Doc Comment", mode = "v" },
      { "<leader>ao", "<cmd>ChatGPTRun opt<cr>", desc = "ChatGPT Optmize code", mode = "v" },
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
          model = "gpt-3.5-turbo",
          -- max_tokens = 300,
        },
        -- openai_edit_params = {
        --   model = "gpt-3.5-turbo",
        -- },
        actions_paths = {
          vim.fn.stdpath "config" .. "/chatgpt/actions.json",
        },
        show_quickfixes_cmd = "quickfix",
      }
    end,
    keys = {
      { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "ChatGPT Prompt" },
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
}
