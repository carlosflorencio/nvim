local M = {}

-- Get the main branch of the git repository
-- @return string
function M.get_base_branch()
  local branch = 'master' -- Default to "master" if "main" is not found
  local handle = io.popen 'git rev-parse --verify --quiet main'

  if handle then
    local result = handle:read '*a'
    handle:close()
    if result ~= '' then
      branch = 'main'
    end
  end

  return branch
end

return M
