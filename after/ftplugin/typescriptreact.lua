-- Automatically end a self-closing tag when pressing /
vim.keymap.set("i", "/", function()
  local ts_utils = require "nvim-treesitter.ts_utils"

  local node = ts_utils.get_node_at_cursor()
  if not node then
    return "/"
  end

  if node:type() == "jsx_opening_element" then
    local char_at_cursor = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline ".", vim.fn.col "." - 2), 0, 1)
    local already_have_space = char_at_cursor == " "

    return already_have_space and "/>" or " />"
  end

  return "/"
end, { expr = true, buffer = true })

-- Automatically add quotes to an attribute when pressing =
vim.keymap.set("i", "=", function()
  -- The cursor location does not give us the correct node in this case, so we
  -- need to get the node to the left of the cursor
  local cursor = vim.api.nvim_win_get_cursor(0)
  local left_of_cursor_range = { cursor[1] - 1, cursor[2] - 1 }

  local node = vim.treesitter.get_node { pos = left_of_cursor_range }
  local nodes_active_in = {
    "property_identifier",
  }

  if not node or not vim.tbl_contains(nodes_active_in, node:type()) then
    -- The cursor is not on an attribute node
    return "="
  end

  return '=""<left>'
end, { expr = true, buffer = true })
