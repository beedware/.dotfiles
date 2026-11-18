return {
  "nvim-treesitter/nvim-treesitter",
  cmd = { "TSInstall", "TSInstallAll", "TSUpdate", "TSUninstall", "TSLog" },
  build = ":TSUpdate",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterFileTypeStart", { clear = true }),
      callback = function(args)
        if not vim.b[args.buf].bigfile then
          pcall(vim.treesitter.start)
        end
      end,
    })
  end,
  config = function()
    vim.api.nvim_create_user_command("TSInstallAll", function()
      require("nvim-treesitter").install(require("tools").treesitter.parsers)
    end, { desc = "Install enabled Treesitter parsers" })
  end,
}
