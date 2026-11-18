vim.opt.makeprg = "make"

vim.opt.errorformat = table.concat({
  "%f:%l:%c: %trror: %m",
  "%f:%l:%c: %tarning: %m",
  "%f:%l: %trror: %m",
  "%f:%l: %tarning: %m",

  "%-Gmake[%*\\d]: Entering directory '%f'",
  "%-Gmake[%*\\d]: Leaving directory '%f'",
  "%-G%\\s%#",
  "%-G%.%#",
}, ",")

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "make",
  callback = function()
    vim.cmd "cwindow"
  end,
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
