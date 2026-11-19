return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    init = function()
      local format_enabled = true
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ConformSave", { clear = true }),
        callback = function(args)
          if format_enabled and vim.bo[args.buf].buftype == "" then
            require("conform").format { bufnr = args.buf, lsp_format = "never", formatters = { "trim_whitespace" } }
          end
        end,
      })
      vim.keymap.set({ "n", "x" }, "<leader>cf", function()
        require("conform").format { lsp_format = "fallback", async = true }
      end, { desc = "Format code" })
      vim.api.nvim_create_user_command("Format", function(opts)
        if opts.args ~= "disable" and opts.args ~= "enable" then
          vim.notify("Usage: Format {disable|enable}", vim.log.levels.ERROR)
          return
        end
        format_enabled = opts.args == "enable"
      end, {
        nargs = 1,
        complete = function()
          return { "disable", "enable" }
        end,
        desc = "Enable or disable format on save",
      })
    end,
    opts = function()
      return { formatters_by_ft = require("tools").quality.formatters_by_ft }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
        callback = function()
          local linters = require("tools").quality.linters_by_ft
          if not linters[vim.bo.filetype] then
            return
          end
          local lint = require "lint"
          lint.linters_by_ft = linters
          lint.try_lint()
        end,
      })
    end,
  },
}
