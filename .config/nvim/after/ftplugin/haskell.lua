local ok, ht = pcall(require, "haskell-tools")
if not ok then
  return
end

local bufnr = vim.api.nvim_get_current_buf()
local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
end

map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
map("<leader>ho", ht.hoogle.hoogle_signature, "Hoogle search for type signature")
map("<leader>ea", ht.lsp.buf_eval_all, "Evaluate Haskell code snippets")
map("<leaderr>rr", ht.repl.toggle, "Toggle Haskell package REPL")
map("<leaderr>rf", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(bufnr))
end, "Toggle Haskell file REPL")
map("<leader>rq", ht.repl.quit, "Quit Haskell REPL")
