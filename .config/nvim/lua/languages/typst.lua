local lsp = require "plugins.lsp"
local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"

lsp.enable { "tinymist" }

treesitter.add { "typst" }

quality.formatters {
  typst = { "prettypst" },
}
