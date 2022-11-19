local ls = require('luasnip')

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

ls.add_snippets(nil, {
  go = {

    snip({
      trig = 'time_layout',
      namr = 'Time Standard Layout',
      dscr = 'The reference time, in numerical order',
    }, {
      text([[// Layout = "01/02 03:04:05PM '06 -0700" The reference time, in numerical order.]]),
    }),

    snip({
      trig = 'time_ansic',
      namr = 'Time ANSIC Layout',
      dscr = 'The reference time, in ANSIC layout',
    }, {
      text([[// ANSIC = "Mon Jan _2 15:04:05 2006"]]),
    }),

    snip({
      trig = 'time_unix',
      namr = 'Time Unix Layout',
      dscr = 'The reference time, in Unix layout',
    }, {
      text([[// UnixDate = "Mon Jan _2 15:04:05 MST 2006"]]),
    }),
  },
})
