local ls = require "luasnip"
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

local condition = function(nodes, inverse)
  local tmp = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    -- Use one column to the left of the cursor to avoid a "chunk" node
    -- type. Not sure what it is, but it seems to be at the end of lines in
    -- some cases.
    local row, col = pos[1] - 1, pos[2] - 1

    local node_type = vim.treesitter
      .get_node({
        pos = { row, col },
      })
      :type()

    if node_type == "ERROR" then
      node_type = vim.treesitter
        .get_node({
          pos = { row, col },
        })
        :parent()
        :type()
    end

    print(vim.inspect(node_type))

    if inverse then
      return vim.tbl_contains(nodes, node_type)
    else
      return not vim.tbl_contains(nodes, node_type)
    end
  end

  return tmp
end

local only = function(nodes)
  return condition(nodes, true)
end

local except = function(nodes)
  return condition(nodes, false)
end

-- local js_if = {
--   s(
--     {
--       trig = "if",
--       condition = condition_ignore_nodes { "string", "comment" },
--     },
--     fmt(
--       [[
-- if ({}) {{
--   {}
-- }}
--   ]],
--       { i(1), i(2) }
--     )
--   ),
-- }

ls.add_snippets("typescriptreact", {
  ls.parser.parse_snippet({ trig = "if", condition = only { "statement_block" } }, "if (${1}) {\n\t$0\n}"),
  ls.parser.parse_snippet({ trig = "class", condition = only { "property_identifier" } }, 'className="${1}"'),
}, {
  type = "autosnippets",
})
