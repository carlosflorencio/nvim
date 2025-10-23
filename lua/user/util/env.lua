local M = {}

function M.is_iterm2()
  local term_program = vim.fn.getenv 'TERM_PROGRAM'
  return term_program == 'iTerm.app'
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
