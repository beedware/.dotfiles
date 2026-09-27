vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
}

local M = {}
local parsers = {}

function M.add(items)
  vim.list_extend(parsers, items)
  require("nvim-treesitter").install(items)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFileTypeStart", { clear = true }),
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end
    pcall(vim.treesitter.start)
  end,
})

vim.api.nvim_create_user_command("TSInstallAll", function()
  require("nvim-treesitter").install(parsers)
end, {
  desc = "Install enabled Treesitter parsers",
})

return M
