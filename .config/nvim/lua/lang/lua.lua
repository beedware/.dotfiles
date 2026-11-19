require("tools").lsp.enable { "lua_ls" }
require("tools").mason.add {
  "lua-language-server",
  "stylua",
}

require("tools").treesitter.add { "lua" }

require("tools").quality.formatters {
  lua = { "stylua" },
}

return {
  "folke/lazydev.nvim",
  ft = "lua",
  cmd = "LazyDev",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "blink.lib", words = { "blink%.cmp", "blink%.lib" } },
    },
  },
}
