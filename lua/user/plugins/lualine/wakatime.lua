-- https://github.com/wakatime/vim-wakatime/issues/110#issuecomment-1407862842
local uv = require 'luv'
local strings = require 'user.util.strings'

local current_time = ''
local function set_interval(interval, callback)
  local timer = uv.new_timer()
  local function ontimeout()
    callback(timer)
  end

  uv.timer_start(timer, interval, interval, ontimeout)
  return timer
end

local function update_wakatime()
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  local handle, _ = uv.spawn('/opt/homebrew/bin/wakatime-cli', {
    args = { '--today' },
    stdio = { stdin, stdout, stderr },
  }, function() -- on exit
    stdin:close()
    stdout:close()
    stderr:close()
  end)

  if not handle then
    print('Failed to run wakatime-cli')
    stdin:close()
    stdout:close()
    stderr:close()
    return
  end

  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      local parsed = strings.trim(data)
      local parts = strings.split(parsed)
      ---@diagnostic disable-next-line: missing-parameter
      if parts[1] ~= nil and parts[3] ~= nil then
        current_time = ' ' .. parts[1] .. 'h' .. parts[3] .. 'm'
      end
    end
  end)
end

set_interval(90000, update_wakatime)

vim.fn.timer_start(2000, function()
  update_wakatime()
end)

function Lualine_get_wakatime()
  return current_time
end
