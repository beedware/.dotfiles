vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("BuiltinLspMappings", { clear = true }),
  callback = function(args)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
  end,
})

vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Show diagnostics in location list" })
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { desc = "Show all diagnostics in quickfix" })

vim.keymap.set("n", "<leader>ta", function()
  if vim.wo.arabic then
    if vim.b._arabic_toggle_manages_spell == nil then
      vim.b._arabic_toggle_manages_spell = vim.wo.spell
    end
    if vim.b._arabic_toggle_manages_spell then
      vim.cmd "set spell"
    end
    vim.cmd "set noarab"
    return
  end
  if vim.b._arabic_toggle_manages_spell == nil then
    vim.b._arabic_toggle_manages_spell = vim.wo.spell
  end
  if vim.b._arabic_toggle_manages_spell then
    vim.cmd "set nospell"
  end
  vim.cmd "set arab"
end, { desc = "Toggle Arabic" })

vim.keymap.set("i", "<C-^>", function()
  if vim.wo.arabic then
    if vim.b._arabic_toggle_manages_spell == nil then
      vim.b._arabic_toggle_manages_spell = vim.wo.spell
    end
    if vim.b._arabic_toggle_manages_spell then
      vim.cmd "set spell"
    end
    return vim.api.nvim_replace_termcodes("<C-o>:set noarab<CR>", true, false, true)
  end
  if vim.b._arabic_toggle_manages_spell == nil then
    vim.b._arabic_toggle_manages_spell = vim.wo.spell
  end
  if vim.b._arabic_toggle_manages_spell then
    vim.cmd "set nospell"
  end
  return vim.api.nvim_replace_termcodes("<C-o>:set arab<CR>", true, false, true)
end, { expr = true, desc = "Toggle Arabic" })
