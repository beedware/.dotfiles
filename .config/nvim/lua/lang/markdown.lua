require("tools").treesitter.add {
  "markdown",
  "markdown_inline",
}

require("tools").quality.formatters {
  markdown = { "prettierd" },
}

return {}
