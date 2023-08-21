local M = {}

M.projectPaths = {}
M.projectPaths["tracker-api"] = "Geartrack/tracker%-api/"

M.buildProjectBefore = function(callback)
  local bufPath = vim.api.nvim_buf_get_name(0)

  if M.bufferInPath(M.projectPaths["tracker-api"], bufPath) then
    vim.notify "Build started"
    local cwd = require("lspconfig").util.root_pattern ".git"(bufPath)
    M.runCmd({ "npm", "run", "build" }, cwd, callback)
    return
  end

  callback()
end

M.runCmd = function(listCmd, cwd, callback)
  vim.fn.jobstart(listCmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    cwd = cwd,
    on_stderr = function(_, data)
      if data then
        print(data)
      end
    end,
    on_exit = function()
      callback()
    end,
  })
end

M.bufferInPath = function(pathPattern, bufPath)
  local path = bufPath

  if path == nil then
    path = vim.api.nvim_buf_get_name(0)
  end

  if string.find(path, pathPattern) then
    return true
  end

  return false
end

return M
