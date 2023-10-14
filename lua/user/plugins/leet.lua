return {
  {
    "Dhanus3133/LeetBuddy.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("leetbuddy").setup {
        language = "js",
        debug = false,
      }
    end,
    keys = {
      { ",lq", "<cmd>LBQuestions<cr>", desc = "List Questions" },
      { ",ll", "<cmd>LBQuestion<cr>", desc = "View Question" },
      { ",lr", "<cmd>LBReset<cr>", desc = "Reset Code" },
      { ",lt", "<cmd>LBTest<cr>", desc = "Run Code" },
      { ",ls", "<cmd>LBSubmit<cr>", desc = "Submit Code" },
    },
  },
}
