local lsp = require "plugins.lsp"
local quality = require "plugins.quality"

lsp.enable { "texlab" }

quality.formatters {
  tex = { "tex-fmt" },
}
