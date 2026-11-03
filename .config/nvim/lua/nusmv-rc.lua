vim.filetype.add {
  extension = {
    smv = "nusmv",
  },
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NuSMVIndent", { clear = true }),
  pattern = "nusmv",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})
