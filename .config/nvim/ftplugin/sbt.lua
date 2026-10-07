vim.opt_global.shortmess:remove "F"

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format { lsp_format = "fallback", async = true, timeout_ms = 10000 }
end, { buffer = true, desc = "Format SBT code" })
