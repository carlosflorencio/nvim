local M = require('lualine.component'):extend()

function M:init(options)
  options.icon = options.icon or ''
  options.split = options.split or ', '
  M.super.init(self, options)
end

function M:update_status()
  local unsaved_files_count = 0

  -- Check for unsaved files in Neovim
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    local filename = vim.api.nvim_buf_get_name(buf_id)
    if filename and filename ~= '' then
      local is_modified = vim.api.nvim_get_option_value('modified', { buf = buf_id })
      if is_modified then
        unsaved_files_count = unsaved_files_count + 1
      end
    end
  end

  return unsaved_files_count > 0 and tostring(unsaved_files_count) or nil
end

return M
