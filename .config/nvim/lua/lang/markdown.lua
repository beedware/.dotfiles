local quality = require("tools").quality
local treesitter = require("tools").treesitter

treesitter.add {
  "markdown",
  "markdown_inline",
}

quality.formatters {
  markdown = { "prettierd" },
}

return {}
