local buffers = require 'user.util.buffers'

local M = {}

M.condition = function(nodes, inverse, word)
  local tmp = function()
    -- prevent snippets from being triggered in the middle of a word
    -- e.g instance.cl does not trigger instance.console.log()
    if buffers.has_words_before(word) then
      return false
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    -- Use one column to the left of the cursor to avoid a "chunk" node
    -- type. Not sure what it is, but it seems to be at the end of lines in
    -- some cases.
    local row, col = pos[1] - 1, pos[2] - 1

    local node = vim.treesitter.get_node { pos = { row, col } }
    local node_type = node and node:type() or nil
    -- print('here[1]: snippets.lua:15: node_type=' .. vim.inspect(node_type))

    if node_type == 'ERROR' then
      node_type = vim.treesitter
        .get_node({
          pos = { row, col },
        })
        :parent()
        :type()
    end

    if inverse then
      return vim.tbl_contains(nodes, node_type)
    else
      return not vim.tbl_contains(nodes, node_type)
    end
  end

  return tmp
end

M.only = function(nodes, word)
  return M.condition(nodes, true, word)
end

M.except = function(nodes, word)
  return M.condition(nodes, false, word)
end

return M
