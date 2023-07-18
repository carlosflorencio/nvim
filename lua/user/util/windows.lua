local M = {}

-- Open or close nvim-tree depending on the number of windows in the current
-- tab
function M.manage_tree_window_open_close(type)
  local nvim_tree_open = M.is_tree_open_current_tab()

  if type == "open" and nvim_tree_open and #vim.api.nvim_tabpage_list_wins(0) > 2 then
    require("nvim-tree.api").tree.close_in_this_tab()
  end

  if type == "close" and not nvim_tree_open and #vim.api.nvim_tabpage_list_wins(0) == 1 then
    -- require("nvim-tree.api").tree.toggle { focus = false }
    require("nvim-tree.api").tree.open()
    vim.cmd [[wincmd l]]
  end
end

-- Close a window and open nvim-tree if it is the last window
function M.close_window()
  vim.cmd [[close]]
  vim.schedule(function()
    require("user.util.windows").manage_tree_window_open_close "close"
  end)
end

-- Open a new vsplit and close nvim-tree if there are more than 2 splits
function M.new_vsplit()
  vim.cmd [[vsplit]]
  vim.schedule(function()
    require("user.util.windows").manage_tree_window_open_close "open"
  end)
end

-- Loops through the windows of the current tab and checks if nvim-tree is
-- one of them
function M.is_tree_open_current_tab()
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tabpage)

  -- check if nvim-tree is open
  local nvim_tree_open = false
  for _, win in ipairs(windows) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if file_type == "NvimTree" then
      return true
    end
  end

  return false
end

-- Open nvim-tree in a tab if there is only one window in the current tab
-- close if there are more than two 2 windows
function M.close_tree_if_many_windows()
  -- layout is more reliable than windows
  -- sometimes there were hidden windows that would skew the count

  -- 27" monitor => 240 cols
  -- 16" laptop => 187 cols
  local editor_width = vim.api.nvim_get_option "columns"
  local windows_to_close_tree = editor_width > 200 and 3 or 2

  -- {"leaf", 1001}, {"row", { {}, {} }}
  local layout = vim.api.nvim_call_function("winlayout", {})
  -- print(vim.inspect(layout))

  -- only 1 or 2 windows
  if layout[1] == "leaf" or #layout[2] == windows_to_close_tree - 1 then
    vim.schedule(function()
      if not require("nvim-tree.api").tree.is_visible() then
        require("nvim-tree.api").tree.toggle {
          focus = false,
        }
      end
    end)
  else
    if #layout[2] > windows_to_close_tree then
      vim.schedule(function()
        require("nvim-tree.api").tree.close()
      end)
    end
  end
end

function M.close_all_floating_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

function M.close_all_nvim_tree_buffers()
  local targetBuffers = {}
  local bufList = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufList) do
    local bufName = vim.api.nvim_buf_get_name(buf)

    if string.match(bufName, "NvimTree") then
      table.insert(targetBuffers, buf)
    end
  end

  for _, buf in ipairs(targetBuffers) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

return M
