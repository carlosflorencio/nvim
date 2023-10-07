return {
  {
    -- task runner
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user" },
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
      log = {
        {
          type = "echo",
          -- was having warnings about npm tasks
          level = vim.log.levels.ERROR,
        },
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)

      vim.api.nvim_create_user_command("WatchRun", function()
        local overseer = require "overseer"
        overseer.run_template({ name = "run script" }, function(task)
          if task then
            task:add_component { "restart_on_save", paths = { vim.fn.expand "%:p" } }
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open vsplit")
            vim.api.nvim_set_current_win(main_win)
          else
            vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
          end
        end)
      end, {})
    end,
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run a Task" },
      { "<leader>ow", "<cmd>WatchRun<cr>", desc = "Run and watch a Task" },
      { "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "Run a Quick Action" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
      { "<leader>oe", "<cmd>OverseerQuickAction<cr>", desc = "Edit the current Task" },
    },
  },
}
