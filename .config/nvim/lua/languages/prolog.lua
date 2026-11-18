local lsp = require "plugins.lsp"
local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("PrologTreesitterParser", { clear = true }),
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").prolog = {
      tier = 4,
      install_info = {
        url = "https://github.com/foxyseta/tree-sitter-prolog",
        revision = "39d5e4e89f336b3bbf245f6fae18473b2e8c88a5",
        location = "grammars/prolog",
        queries = "grammars/prolog/queries",
      },
    }
  end,
})

vim.treesitter.language.register("prolog", "prolog")

lsp.enable { "prolog_ls" }

treesitter.add { "prolog" }

quality.formatters {
  prolog = { "prolog" },
}
