local ls = require('luasnip')

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets(nil, {
  sh = {
    snip(
      {
        trig = 'bash',
        namr = 'Bash working layout',
        dscr = 'Shabang and error handling in bash',
      },
      fmta(
        [[
#!/usr/bin/env bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail
      ]],
        {}
      )
    ),
  },
})
