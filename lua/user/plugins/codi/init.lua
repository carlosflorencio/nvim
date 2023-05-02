return {
  {
    -- scratch files
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
    keys = {
      {
        "<leader>tr",
        function()
          require("user.plugins.codi.utils").FullscreenScratch()
        end,
        desc = "New Tab Repl (Codi)",
      },
    },
  },

  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  },
}
