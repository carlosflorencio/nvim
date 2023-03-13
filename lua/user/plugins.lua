return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function() vim.cmd.colorscheme "bluloco" end,
  },

  {
    -- Detect tabstop and shiftwidth automatically
    "nmac427/guess-indent.nvim",
    lazy = false,
  },

  {
    import = "user.plugins",
  },
}
