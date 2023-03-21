return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local components = require "user.plugins.lualine.components"
      local package_info = require "package-info"
      require "user.plugins.lualine.wakatime"

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "lazy", "alpha" },
          },
          ignore_focus = {
            "NvimTree",
            "lir",
            "dapui_watches",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dapui_stacks",
            "dap-repl",
          },
        },

        sections = {
          lualine_a = { components.mode },
          lualine_b = { components.branch },
          lualine_c = {
            "lsp_progress",
            package_info.get_status,
            require("recorder").recordingStatus,
            components.python_env,
          },
          lualine_x = { components.lsp, components.filetype, "searchcount", Lualine_get_wakatime },
          lualine_y = { "overseer", components.diagnostics },
          lualine_z = {},
        },
        extensions = {},
      }
    end,
  },
  {
    -- statuslune lsp progress
    "arkav/lualine-lsp-progress",
  },
}
