return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup {
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.8 },
                  -- { id = "breakpoints", size = 0.25 },
                  -- { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.2 },
                },
                position = "right",
                size = 50,
              },
              {
                elements = {
                  { id = "console", size = 0.5 },
                  { id = "repl", size = 0.5 },
                },
                position = "bottom",
                size = 10,
              },
            },
          }
        end,
        keys = {
          { ",U", "<cmd>lua require('dapui').toggle()<CR>", desc = "Toggle DAP UI" },
          { ",C", "<cmd>lua require('dapui').close()<CR>", desc = "Close DAP UI" },
          {
            ",dd",
            function()
              require("dapui").eval()
            end,
            desc = "Debug Hover Evaluate Expression",
          },
        },
      },
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require "dap"

      for _, language in ipairs { "javascript", "javascriptreact" } do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      for _, language in ipairs { "typescript", "typescriptreact" } do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file Typescript",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "ts-node",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      -- auto open dap ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      -- auto close dap ui
      dap.listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end

      --icons
      local user_icons = require("user.ui").icons
      vim.fn.sign_define("DapBreakpoint", {
        text = user_icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = user_icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = user_icons.ui.BoldArrowRight,
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })
    end,
    keys = {
      {
        ",df",
        function()
          require("user.cmds").buildProjectBefore(function()
            require("dap").continue()
          end)
        end,
        desc = "Debug File",
      },
      {
        ",dso",
        "<cmd>lua require('dap').step_over()<cr>",
        desc = "Debug step over",
      },
      {
        ",dsO",
        "<cmd>lua require('dap').step_out()<cr>",
        desc = "Debug step out",
      },
      {
        ",dsi",
        "<cmd>lua require('dap').step_into()<cr>",
        desc = "Debug step into",
      },
      {
        ",dc",
        "<cmd>lua require('dap').continue()<cr>",
        desc = "Debug continue",
      },
      {
        ",dt",
        "<cmd>lua require('dap').terminate()<cr>",
        desc = "Debug terminate",
      },
      {
        ",bb",
        "<cmd>lua require('dap').toggle_breakpoint()<cr>",
        desc = "Debug add breakpoint",
      },
    },
  },

  {
    -- vscode debug adapter install
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npm run compile",
    -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/23
    tag = "v1.74.1",
  },

  {
    -- dap adapter for the newer vscode-js debugger
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap", "microsoft/vscode-js-debug" },
    opts = {
      -- fix sourcemaps console errors https://github.com/mxsdev/nvim-dap-vscode-js/issues/35
      adapters = { "pwa-node", "node-terminal" },
      debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
    },
  },

  {
    "Weissle/persistent-breakpoints.nvim",
    enabled = false,
    event = "BufReadPost",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      {
        ",bb",
        "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
        desc = "Toggle breakpoint",
      },
      {
        ",bc",
        "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
        desc = "Conditional breakpoint",
      },
      {
        ",bd",
        "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
        desc = "Delete all breakpoints",
      },
    },
  },

  {
    "ofirgall/goto-breakpoints.nvim",
    keys = {
      {
        "]b",
        function()
          require("goto-breakpoints").next()
        end,
        desc = "Next breakpoint",
      },
      {
        "[b",
        function()
          require("goto-breakpoints").prev()
        end,
        desc = "Previous breakpoint",
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },

  {
    "leoluz/nvim-dap-go",
    opts = {},
    ft = { "go" },
  },
}
