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
    vim.api.nvim_create_user_command("TSInstallAll", function(args)
      local task = require("nvim-treesitter").install(require("tools").treesitter.parsers, { summary = true })
      if args.bang or #vim.api.nvim_list_uis() == 0 then
        assert(task:wait(), "Treesitter parser installation failed; see output above")
      end
    end, { bang = true, desc = "Install enabled Treesitter parsers (! waits for completion)" })
  end,
}
