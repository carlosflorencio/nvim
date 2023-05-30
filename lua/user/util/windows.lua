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

return M
