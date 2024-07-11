local M = {}

function M.is_iterm2()
  local term_program = vim.fn.getenv 'TERM_PROGRAM'
  return term_program == 'iTerm.app'
end

return M
