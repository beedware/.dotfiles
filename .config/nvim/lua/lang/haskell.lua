require("tools").mason.add { "fourmolu", "hlint" }

require("tools").quality.formatters {
  haskell = { "fourmolu" },
}

vim.g.haskell_tools = {
  tools = {
    codeLens = { autoRefresh = false },
  },
}

return {
  "MrcJkb/haskell-tools.nvim",
  version = "v11.0.0",
  lazy = false,
}
