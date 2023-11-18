return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local components = require "user.plugins.lualine.components"
      require "user.plugins.lualine.wakatime"
      -- local disabled_filetypes = require("user.util.constants").disabled_filetypes

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          refresh = {
            statusline = 2000,
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "lazy", "alpha", "NvimTree", "TelescopePrompt" },
          },
          ignore_focus = {
            "NvimTree",
            "chatgpt-input",
            "oil",
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
            -- "lsp_progress",
            {
              function()
                return require("package-info").get_status()
              end,
              cond = function()
                return package.loaded["package-info"] ~= nil
              end,
            },

            components.recording_macro,
            -- require("recorder").recordingStatus,
            components.python_env,
          },
          lualine_x = {
            components.location,
            "fancy_lsp_servers",
            {
              function()
                return require("codegpt").get_status()
              end,
              cond = function()
                return package.loaded["codegpt"] ~= nil
              end,
            },
            -- "codeium#GetStatusString", -- has an issue, makes entering buffers in insert mode
            {
              function()
                return require("wtf").get_status()
              end,
              cond = function()
                return package.loaded["wtf"] ~= nil
              end,
            },
            components.filetype,
            "searchcount",
            Lualine_get_wakatime,
          },
          lualine_y = {
            {
              function()
                return "overseer"
              end,
              cond = function()
                return package.loaded["overseer"] ~= nil
              end,
            },
            components.diagnostics,
          },
          lualine_z = {},
        },
        extensions = {},
      }
    end,
  },
}
