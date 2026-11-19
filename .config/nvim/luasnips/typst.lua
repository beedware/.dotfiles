local ls = require "luasnip"

local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("typst", {
  ls.snippet("zettel", {
    t {
      '#import ".utility/style.typ": style',
      "#show: style",
      "",
      '#let title = "',
    },
    i(1, "Title"),
    t {
      '"',
      "",
      "",
    },
    i(2, ":ghost:"),
    t {
      "",
      "",
      "= #title",
      "",
    },
    i(0),
    t {
      "",
      "",
      "= Links",
      "",
      "",
      '#bibliography(".utility/sources.yaml")',
    },
  }),
})
