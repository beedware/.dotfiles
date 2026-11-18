local lsp = require "plugins.lsp"
local mason = require "plugins.mason"
local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"

lsp.enable { "lua_ls" }
mason.add {
  "lua-language-server",
  "stylua",
}

treesitter.add { "lua" }

quality.formatters {
  lua = { "stylua" },
}
