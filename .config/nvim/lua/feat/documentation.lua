return {
  "danymat/neogen",
  cmd = "Neogen",
  dependencies = { vim.deepcopy(require "deps.snippets") },
  keys = { { "<leader>ca", "<cmd>Neogen<cr>", desc = "Generate code annotation" } },
  opts = { snippet_engine = "luasnip" },
}
