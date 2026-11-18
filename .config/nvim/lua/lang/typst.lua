local lsp = require("tools").lsp
local quality = require("tools").quality
local treesitter = require("tools").treesitter

lsp.enable { "tinymist" }

treesitter.add { "typst" }

quality.formatters {
  typst = { "prettypst" },
}

return {}
