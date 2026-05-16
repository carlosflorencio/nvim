local M = {}

function M.delete_unlisted_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_get_option_value('buflisted', { buf = buf }) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function M.delete_buffers_filetype(filetypes)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
    if vim.tbl_contains(filetypes, filetype) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

function M.close_tmp_buffers()
  M.delete_unlisted_buffers()
  M.delete_buffers_filetype { 'oil', 'TelescopePrompt', 'copilot-chat', 'grug-far', 'codecompanion' }
end

return M
