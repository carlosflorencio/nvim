local M = {}

-- Open nvim-tree in a tab if there is only one window in the current tab
-- close if there are more than two 2 windows
function M.close_tree_if_many_windows()
  if package.loaded['dap'] ~= nil then
    local current_debug_session = require('dap').session()

    if current_debug_session ~= nil then
      -- ignore window arrangment when debugging
      return
    end
  end

  -- layout is more reliable than windows
  -- sometimes there were hidden windows that would skew the count

  -- 27" monitor => 240 cols
  -- 16" laptop => 187 cols
  -- local editor_width = vim.api.nvim_get_option 'columns'
  -- local windows_to_close_tree = editor_width > 200 and 3 or 2
  local windows_to_close_tree = 2

  -- {"leaf", 1001}, {"row", { {}, {} }}
  local layout = vim.api.nvim_call_function('winlayout', {})
  -- print(vim.inspect(layout) .. os.date '%Y-%m-%d %H:%M:%S')

  -- only 1 or 2 windows

  if layout[1] == 'leaf' or #layout[2] == windows_to_close_tree - 1 then
    if not require('nvim-tree.api').tree.is_visible() then
      pcall(function()
        require('nvim-tree.api').tree.toggle {
          focus = false,
        }
      end)
    else
      -- close the current tab since nvim-tree is the only buffer left
      if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd [[tabclose]]
      else
        vim.cmd [[q]]
      end
    end
  else
    if #layout[2] > windows_to_close_tree then
      require('nvim-tree.api').tree.close()
    end
  end
end

function M.delete_unlisted_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_buf_get_option(buf, 'buflisted') then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

function M.delete_buffers_filetype(filetypes)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    if vim.tbl_contains(filetypes, filetype) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

function M.close_tmp_buffers()
  M.delete_unlisted_buffers()
  M.delete_buffers_filetype { 'oil', 'NvimTree', 'TelescopePrompt', 'copilot-chat' }
end

function M.close_all_nvim_tree_buffers()
  require('nvim-tree.api').tree.close_in_all_tabs()
  local targetBuffers = {}
  local bufList = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufList) do
    local bufName = vim.api.nvim_buf_get_name(buf)

    if string.match(bufName, 'NvimTree') then
      table.insert(targetBuffers, buf)
    end
  end

  for _, buf in ipairs(targetBuffers) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

return M
