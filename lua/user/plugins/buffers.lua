return {
  {
    -- Automagically close the unedited buffers
    "axkirillov/hbac.nvim",
    lazy = false,
    config = function()
      require("hbac").setup {
        threshold = 10,
      }
    end,
  },

  {
    -- sort buffers by frencency
    "dzfrias/arena.nvim",
    enabled = true,
    event = "BufWinEnter",
    opts = {
      max_items = 10,
      always_context = { "mod.rs", "init.lua", "package.json" },
      ignore_current = true,
      per_project = false,
    },
    keys = {
      {
        "<leader>j",
        function()
          require("arena").toggle()
        end,
        desc = "Switch Buffers",
      },
    },
  },
}
