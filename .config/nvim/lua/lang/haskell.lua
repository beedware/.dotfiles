require("tools").mason.add { "haskell-language-server", "fourmolu", "hlint" }

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
