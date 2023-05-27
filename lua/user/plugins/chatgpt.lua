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
            close = { "<C-c>" },
          },
        },
        edit_with_instructions = {
          diff = true,
          keymaps = {
            close = { "<C-c>" },
          },
        },
        popup_layout = {
          default = "right",
        },
        popup_input = {
          submit = "<Enter>",
          submit_n = "<Enter>",
        },
        actions_paths = {
          vim.fn.stdpath "config" .. "/chatgpt/actions.json",
        },
        show_quickfixes_cmd = "quickfix",
      }
    end,
    keys = {
      { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "ChatGPT Prompt" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", desc = "ChatGPT Edit with Instructions", mode = "v" },
      {
        "<leader>ar",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        desc = "ChatGPT Readibility Analysis",
        mode = "v",
      },
      -- { "<leader>ar", "<cmd>ChatGPTRun<tab>", desc = "ChatGPT Run Mode", mode = "v" },
    },
  },

  -- {
  --   "james1236/backseat.nvim",
  --   config = function()
  --     require("backseat").setup {
  --       openai_model_id = "gpt-3.5-turbo", --gpt-4 (If you do not have access to a model, it says "The model does not exist")

  --       -- split_threshold = 100,
  --       -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
  --       -- highlight = {
  --       --     icon = '', -- ''
  --       --     group = 'Comment',
  --       -- }
  --     }
  --   end,
  --   cmd = {
  --     "Backseat",
  --     "BackseatAsk",
  --     "BackseatClear",
  --     "BackseatClearLine",
  --   },
  -- },
}
