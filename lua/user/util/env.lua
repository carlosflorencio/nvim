local M = {}

function M.is_iterm2()
  local term_program = vim.fn.getenv 'TERM_PROGRAM'
  return term_program == 'iTerm.app'
end

--- Check if the current machine is a work machine
--- Work machines have hostnames starting with "PT"
---@return boolean
function M.is_work()
  local hostname = vim.fn.hostname()
  return hostname:match("^PT") ~= nil
end

--- Check if the current machine is a personal machine
--- Any machine that is not a work machine is considered personal
---@return boolean
function M.is_personal()
  return not M.is_work()
end

function M.node_path()
  local handle = io.popen 'mise where node@latest'
  if not handle then
    return nil, "Failed to execute 'mise where node@latest'"
  end

  local path = handle:read('*a'):match '^%s*(.-)%s*$' -- Read output and trim whitespace
  handle:close()

  if not path or path == '' then
    return nil, 'No path found for node@latest'
  end

  return path, nil
end

return M
