local ls = require 'luasnip'
local common = require 'user.snippets.common'
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local postfix = require('luasnip.extras.postfix').postfix

local const_pf = postfix('.const', {
  d(1, function(_, parent)
    return sn(nil, {
      t 'const ',
      i(1, 'var'),
      t ' = ',
      t(parent.env.POSTFIX_MATCH),
    })
  end),
})

local let_pf = postfix('.let', {
  d(1, function(_, parent)
    return sn(nil, {
      t 'let ',
      i(1, 'var'),
      t ' = ',
      t(parent.env.POSTFIX_MATCH),
    })
  end),
})
local if_pf = postfix({ trig = '.if', match_pattern = '^.+$' }, {
  d(1, function(_, parent)
    return sn(nil, {
      t 'if (',
      t(parent.env.POSTFIX_MATCH),
      t { ') {', '' },
      t '\t',
      i(1),
      t { '', '}' },
    })
  end),
})

local ts_if = 'if (${1}) {\n\t$0\n}'
local ts_switch = 'switch (${1}) {\n\tcase ${2}:\n\t\t$0\n\tbreak\n}'
local ts_try = 'try {\n\t${1}\n} catch (${2}) {\n\t$0\n}'
local ts_while = 'while (${1}) {\n\t$0\n}'
local ts_doc = '/**\n * $0\n */'
local ts_cl = 'console.log($0)'

ls.add_snippets('typescriptreact', {
  ls.parser.parse_snippet({ trig = 'if', condition = common.only({ 'statement_block' }, 'if') }, ts_if),
  ls.parser.parse_snippet({ trig = 'class', condition = common.only({ 'property_identifier' }, 'class') }, 'className="${1}"'),
  ls.parser.parse_snippet({ trig = 'switch', condition = common.only({ 'statement_block' }, 'switch') }, ts_switch),
  ls.parser.parse_snippet({ trig = 'try', condition = common.only({ 'statement_block' }, 'try') }, ts_try),
  ls.parser.parse_snippet({ trig = 'while', condition = common.only({ 'statement_block' }, 'while') }, ts_while),
}, {
  type = 'autosnippets',
})

ls.add_snippets('typescript', {
  ls.parser.parse_snippet({ trig = 'if', condition = common.only({ 'statement_block', 'program' }, 'if') }, ts_if),
  ls.parser.parse_snippet({ trig = 'switch', condition = common.only({ 'statement_block', 'program' }, 'switch') }, ts_switch),
  ls.parser.parse_snippet({ trig = 'try', condition = common.only({ 'statement_block', 'program' }, 'try') }, ts_try),
  ls.parser.parse_snippet({ trig = 'while', condition = common.only({ 'statement_block', 'program' }, 'while') }, ts_while),
  ls.parser.parse_snippet({ trig = 'cl', condition = common.only({ 'statement_block', 'program' }, 'cl') }, ts_cl),
  ls.parser.parse_snippet({ trig = '/**', condition = common.only({ 'statement_block', 'program' }, '/**') }, ts_doc),
}, {
  type = 'autosnippets',
})
ls.add_snippets('typescript', { const_pf, let_pf, if_pf })
