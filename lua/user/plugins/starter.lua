return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            {
              desc = "󰱼 Files",
              group = "Label",
              action = "lua require('telescope').extensions.smart_open.smart_open()",
              key = "f",
            },
          },
          project = {
            enable = false,
          },
          mru = {
            cwd_only = true,
          },
        },
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
