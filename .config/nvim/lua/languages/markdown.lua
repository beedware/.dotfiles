local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"

treesitter.add {
  "markdown",
  "markdown_inline",
}

quality.formatters {
  markdown = { "prettierd" },
}
