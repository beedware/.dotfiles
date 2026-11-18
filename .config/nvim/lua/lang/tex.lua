local lsp = require("tools").lsp
local quality = require("tools").quality

lsp.enable { "texlab" }

quality.formatters {
  tex = { "tex-fmt" },
}

return {}
