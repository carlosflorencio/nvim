local neotest = require("neotest")
local neotestLib = require("neotest.lib")
local cmds = require("user.cmds")

neotest.setup({
  diagnostic = {
    enabled = true,
    severity = 1
  },
  log_level = vim.log.levels.DEBUG,
  quickfix = {
    enabled = false,
    open = false
  },
  adapters = {
    require('neotest-jest')({
      jestCommand = "npx jest",
      -- jestConfigFile = "jest.config.ts",
      -- env = { CI = false },
      cwd = function(path)
        local root = neotestLib.files.match_root_pattern("package.json")(path)

        -- vim.notify("found root " .. root)
        return root
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
    }),
  }
})

-- Run tests on file save
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("cf-autoruntests", { clear = true }),
--   pattern = "*.test.ts",
--   callback = function()
--     local path = vim.api.nvim_buf_get_name(0)

--     vim.schedule(function()
--       neotest.run.run(path)
--     end)

--     -- vim.notify("Running Tests", "info", {
--     --   timeout = 1000
--     -- })
--   end
-- })

