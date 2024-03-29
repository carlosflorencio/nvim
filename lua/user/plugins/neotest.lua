--local cmds = require("user.cmds")

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "mfussenegger/nvim-dap",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest = require "neotest"
      local neotestLib = require "neotest.lib"

      neotest.setup {
        diagnostic = {
          enabled = true,
          severity = 1,
        },
        -- log_level = vim.log.levels.DEBUG,
        quickfix = {
          enabled = false,
          open = false,
        },
        discovery = {
          concurrent = 0,
          -- disabled, otherwise it would scan all test files during runtime
          enabled = false,
        },
        projects = {
          ["~/Exercism/go"] = {
            discovery = {
              enabled = true,
            },
          },
        },
        adapters = {
          require "neotest-go",
          require "neotest-jest" {
            jestCommand = "npx jest",
            jestConfigFile = function(currentFile)
              local currentFolder = vim.fn.expand "%:p:h"
              local packageRoot = neotestLib.files.match_root_pattern "package.json"(currentFolder)

              -- print(vim.inspect(currentFolder))
              -- print(vim.inspect(packageRoot))

              if string.find(packageRoot, "bff%-channel%-guide") then
                -- different config files per types of test
                local suffix = string.match(currentFile, "%.(%w+)%.ts$")
                if suffix then
                  return packageRoot .. "/tests/config/jest." .. suffix .. ".config.json"
                end
              end

              if string.find(packageRoot, "bff/galley") then
                -- different config files per types of test
                return "jest.config.js"
              end

              if string.find(packageRoot, "tracker%-api") then
                return "jest.config.js"
              end

              return "jest.config.ts"
            end,
            -- env = { CI = false },
            cwd = function(path)
              local root = neotestLib.files.match_root_pattern "package.json"(path)

              return root
            end,
            env = function()
              return {
                -- ["JEST_HTML_REPORTERS_OPEN_REPORT"] = "",
                ["NODE_ENV"] = "test", -- prevent report from opening
              }
            end,
            -- strategy_config = function(args)
            --   -- if cmds.bufferInPath(cmds.projectPaths["tracker-api"]) then
            --   --   vim.notify("is tracker api")
            --   -- end

            --   local testFilePath = args.args[#args.args]
            --   print("test file " .. vim.inspect(testFilePath))
            --   print("args " .. vim.inspect(args))

            --   -- print("new args from old" .. vim.inspect({ unpack(args.args, 2) }))
            --   -- args.runtimeExecutable = "jest"
            --   -- args.program = "/Users/carlosflorencio/.local/share/nvm/v16.18.1/bin/jest"
            --   -- args.args = { unpack(args.args, 2) }

            --   -- node2
            --   -- args.program = "${workspaceFolder}/node_modules/jest/bin/jest.js"
            --   -- args.type = "node2"
            --   -- args.protocol = "inspector"
            --   -- args.sourceMaps = "inline"
            --   -- args.request = "launch"
            --   -- args.restart = true
            --   -- args.runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" }
            --   args.runtimeExecutable = "node"
            --   args.runtimeArgs = {
            --     "./node_modules/jest/bin/jest.js",
            --     "--runInBand",
            --   }

            --   vim.notify("strategy_config")
            --   print("strategy config" .. vim.inspect(args))

            --   return args
            -- end
          },
        },
      }
    end,
    keys = {
      {
        ",tu",
        function()
          require("user.cmds").buildProjectBefore(function()
            require("neotest").run.run()
          end)
        end,
        desc = "Run nearest test under cursor",
      },
      {
        ",tt",
        function()
          require("user.cmds").buildProjectBefore(function()
            require("neotest").run.run(vim.fn.expand "%")
          end)
        end,
        desc = "Test file",
      },
      {
        ",td",
        function()
          require("user.cmds").buildProjectBefore(function()
            require("neotest").run.run {
              strategy = "dap",
            }
          end)
        end,
        desc = "Debug nearest test under cursor",
      },
      { ",to", '<cmd>lua require("neotest").output.open()<cr>', desc = "Test Output" },
      { ",tp", '<cmd>lua require("neotest").output_panel.toggle()<cr>', desc = "Test Output Panel" },
      { ",ts", '<cmd>lua require("neotest").summary.toggle()<cr>', desc = "Toggle Test Summary" },
      { ",ta", '<cmd>lua require("neotest").run.run(vim.fn.getcwd())<cr>', desc = "Run tests in current directory" },
      -- {
      --   ",dt",
      --   function()
      --     require("user.cmds").buildProjectBefore(function()
      --       require("neotest").run.run {
      --         vim.fn.expand "%",
      --         strategy = "dap",
      --       }
      --     end)
      --   end,
      --   desc = "Debug Test File",
      -- },
    },
  },
}
