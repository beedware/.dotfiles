local lsp = require("tools").lsp
local mason = require("tools").mason
local quality = require("tools").quality
local treesitter = require("tools").treesitter

lsp.enable { "lua_ls" }
mason.add {
  "lua-language-server",
  "stylua",
}

treesitter.add { "lua" }

quality.formatters {
  lua = { "stylua" },
}

return {
  "folke/lazydev.nvim",
  ft = "lua",
  cmd = "LazyDev",
  opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
}
