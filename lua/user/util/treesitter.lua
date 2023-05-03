local ts_utils = require "nvim-treesitter.ts_utils"

-- inspirations
-- https://github.com/jcha0713/classy.nvim/blob/main/lua/classy/init.lua#L95
-- https://jhcha.app/blog/the-power-of-treesitter/

local M = {}

function M.go_to_next_jsx_element()
  local filetype = vim.api.nvim_buf_get_option(0, "ft")
  local lang = require("nvim-treesitter.parsers").ft_to_lang(filetype)
  -- local query_text = [[ ((jsx_element) @jsxNode) ]] -- your query
  -- local query = vim.treesitter.query.parse_query(lang, query_text)

  local node = ts_utils.get_node_at_cursor()
  print(vim.inspect(node:type()))

  -- if not node then
  --   error "No Treesitter parser found."
  --   return
  -- end

  -- Percolate up the lang tree until it reaches the nearest element tag
  while M.is_not_element(node, lang) do
    if node:child() == nil then
      return
    end
    node = node:parent()
  end

  vim.pretty_print(node)
  vim.notify(vim.inspect(node))
end

M.is_not_element = function(node, lang)
  if M.is_jsx(lang) then
    return node:type() ~= "jsx_element" and node:type() ~= "jsx_self_closing_element"
  else
    return node:type() ~= "element"
  end
end

M.is_jsx = function(lang)
  return (lang == "javascript" or lang == "typescript" or lang == "tsx")
end

return M
