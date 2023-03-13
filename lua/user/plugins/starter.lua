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
              desc = " Update",
              group = "@property",
              action = "Lazy update",
              key = "u",
            },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "lua require('telescope').extensions.smart_open.smart_open()",
              key = "f",
            },
          },
        },
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
