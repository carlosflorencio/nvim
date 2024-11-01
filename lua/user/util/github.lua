local Job = require 'plenary.job'
local M = {}

function M.fetch_pr_branch(pr_url, callback)
  -- Extract the necessary parts from the PR URL
  local owner, repo, pr_number = pr_url:match 'github.com/(.-)/(.-)/pull/(%d+)'
  if not owner or not repo or not pr_number then
    callback(nil, 'Invalid PR URL')
    return
  end

  -- Get GitHub Personal Access Token from environment variable
  local token = os.getenv 'GITHUB_TOKEN'
  if not token then
    callback(nil, 'Error: GITHUB_TOKEN environment variable is not set')
    return
  end

  -- GitHub API URL
  local api_url = string.format('https://api.github.com/repos/%s/%s/pulls/%s', owner, repo, pr_number)

  -- Make the HTTP request
  Job:new({
    command = 'curl',
    args = {
      '-H',
      'Authorization: token ' .. token,
      api_url,
    },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        callback(nil, 'Failed to fetch PR information')
        return
      end

      local response = table.concat(j:result(), '\n')
      local data = nil
      local success, err = pcall(function()
        data = vim.fn.json_decode(response)
      end)

      if not success or not data then
        callback(nil, 'Failed to decode JSON response: ' .. (err or 'unknown error'))
        return
      end

      if data and data.head and data.head.ref then
        callback(data.head.ref, nil)
      else
        callback(nil, 'Failed to extract branch name')
      end
    end,
  }):start()
end

return M
