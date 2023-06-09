return {
  {
    -- task runner
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "right",
        bindings = {
          ["?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-i>"] = "IncreaseDetail",
          ["<C-o>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
        },
      },
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run a Task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
      { "<leader>oe", "<cmd>OverseerQuickAction<cr>", desc = "Edit the current Task" },
    },
  },
}
