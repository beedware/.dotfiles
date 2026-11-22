require("tools").treesitter.add {
  "markdown",
  "markdown_inline",
}

require("tools").mason.add {
  "prettierd",
}

require("tools").quality.formatters {
  markdown = { "prettierd" },
}

return {}
