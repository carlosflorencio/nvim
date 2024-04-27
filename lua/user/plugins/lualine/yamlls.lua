local M = require('lualine.component'):extend()

function M:init(options)
  options.icon = options.icon or '󰌘'
  options.split = options.split or ', '
  M.super.init(self, options)
end

local method = 'yaml/get/jsonSchema'
local sync_timeout = 5000

local function current_schema()
  local bufnr = vim.api.nvim_get_current_buf()
  if not bufnr then
    print 'no current buffer'
    return
  elseif vim.bo[bufnr].filetype ~= 'yaml' then
    print 'current buffer is not yaml'
    return
  end
  local clients = vim.lsp.get_active_clients { name = 'yamlls', bufnr = bufnr }
  if not clients or #clients == 0 or not clients[1] then
    print 'no yamlls client'
    return
  end
  local client = clients[1]
  local response, error = client.request_sync(method, { vim.uri_from_bufnr(bufnr) }, sync_timeout, bufnr)
  if error then
    print('bufnr=%d error=%s', bufnr, error)
    return
  elseif not response then
    print('bufnr=%d response=nil', bufnr)
    return
  elseif response.err then
    print('bufnr=%d response.err=%s', bufnr, response.err)
    return
  elseif #response.result == 0 then
    print 'no schema for current buffer'
    return
  end
  local schema = response.result[1]
  return schema.uri
  -- print(vim.inspect(schema))
  -- print('bufnr=%d schema=%s', bufnr, vim.inspect(schema))
  -- -- comment above line and uncomment blow if you have nvim-notify
  -- vim.notify((schema.description or '') .. '\n' .. (schema.uri or ''), vim.log.levels.INFO, { title = schema.name })
end

function M:update_status()
  return current_schema()
  -- return 'run'
end

return M
