return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterFileTypeStart", { clear = true }),
      callback = function(args)
        if vim.b[args.buf].bigfile then
          vim.treesitter.stop(args.buf)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              vim.bo[args.buf].syntax = "OFF"
            end
          end)
          return
        end
        pcall(vim.treesitter.start, args.buf)
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
