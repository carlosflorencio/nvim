return {
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      { "folke/snacks.nvim" }, -- optional
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    -- build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" }, -- optional
    opts = {
      window = {
        type = "vsplit",     -- split | vsplit
      },
      picker = {
        type = "snacks", -- native (vim.ui.select) | telescope | snacks | mini | fzf_lua
        -- see respective picker in lua/godoc/pickers for available options
        snacks = {},
      },
    }, -- see further down below for configuration
  }
}
