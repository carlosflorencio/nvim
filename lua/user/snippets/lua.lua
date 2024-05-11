local ls = require 'luasnip'
local t = ls.text_node
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local postfix = require('luasnip.extras.postfix').postfix

local local_pf = postfix('.local', {
  d(1, function(_, parent)
    return sn(nil, {
      t 'local ',
      i(1, 'var'),
      t ' = ',
      t(parent.env.POSTFIX_MATCH),
    })
  end),
})

local lua_pp = 'print(vim.inspect(${1}))'

ls.add_snippets('lua', {
  ls.parser.parse_snippet({ trig = 'pp' }, lua_pp),
}, {
  type = 'autosnippets',
})

ls.add_snippets('lua', { local_pf })
