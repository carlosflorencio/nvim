return {
  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "MunifTanjim/nui.nvim" },
    },
    cmd = "Chat",
  },

  {
    "james1236/backseat.nvim",
    config = function()
      require("backseat").setup {
        openai_model_id = "gpt-3.5-turbo", --gpt-4 (If you do not have access to a model, it says "The model does not exist")

        -- split_threshold = 100,
        -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
        -- highlight = {
        --     icon = '', -- ''
        --     group = 'Comment',
        -- }
      }
    end,
    cmd = {
      "Backseat",
      "BackseatAsk",
      "BackseatClear",
      "BackseatClearLine",
    },
  },
}
