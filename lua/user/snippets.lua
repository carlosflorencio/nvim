local ls = require 'luasnip'
local s = ls.s
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node

local condition = function(nodes, inverse)
  local tmp = function()
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

local only = function(nodes)
  return condition(nodes, true)
end

local except = function(nodes)
  return condition(nodes, false)
end

local ts_if = 'if (${1}) {\n\t$0\n}'
local ts_switch = 'switch (${1}) {\n\tcase ${2}:\n\t\t$0\n\tbreak\n}'
local ts_try = 'try {\n\t${1}\n} catch (${2}) {\n\t$0\n}'
local ts_while = 'while (${1}) {\n\t$0\n}'
local ts_cl = 'console.log($0)'
local lua_pp = 'print(vim.inspect(${1}))'

ls.add_snippets('typescriptreact', {
  ls.parser.parse_snippet({ trig = 'if', condition = only { 'statement_block' } }, ts_if),
  ls.parser.parse_snippet({ trig = 'class', condition = only { 'property_identifier' } }, 'className="${1}"'),
  ls.parser.parse_snippet({ trig = 'switch', condition = only { 'statement_block' } }, ts_switch),
  ls.parser.parse_snippet({ trig = 'try', condition = only { 'statement_block' } }, ts_try),
  ls.parser.parse_snippet({ trig = 'while', condition = only { 'statement_block' } }, ts_while),
}, {
  type = 'autosnippets',
})

local jsts = { 'javascript', 'typescript' }
for _, lang in ipairs(jsts) do
  ls.add_snippets(lang, {
    ls.parser.parse_snippet({ trig = 'if', condition = only { 'statement_block', 'program' } }, ts_if),
    ls.parser.parse_snippet({ trig = 'switch', condition = only { 'statement_block', 'program' } }, ts_switch),
    ls.parser.parse_snippet({ trig = 'try', condition = only { 'statement_block', 'program' } }, ts_try),
    ls.parser.parse_snippet({ trig = 'while', condition = only { 'statement_block', 'program' } }, ts_while),
    ls.parser.parse_snippet({ trig = 'cl', condition = only { 'statement_block', 'program' } }, ts_cl),
  }, {
    type = 'autosnippets',
  })
end

ls.add_snippets('lua', {
  ls.parser.parse_snippet({ trig = 'pp' }, lua_pp),
}, {
  type = 'autosnippets',
})
