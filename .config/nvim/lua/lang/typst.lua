require("tools").lsp.enable { "tinymist" }

require("tools").treesitter.add { "typst" }

require("tools").quality.formatters {
  typst = { "prettypst" },
}

return {}
