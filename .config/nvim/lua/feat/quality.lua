local format_enabled = true

return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    event = "BufWritePre",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { lsp_format = "fallback", async = true }
        end,
        mode = { "n", "x" },
        desc = "Format code",
      },
    },
    init = function()
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
      return {
        formatters_by_ft = require("tools").quality.formatters_by_ft,
        format_on_save = function(bufnr)
          if format_enabled then
            return { bufnr = bufnr, formatters = { "trim_whitespace" } }
          end
        end,
      }
    end,
  },
  {
    url = "https://codeberg.org/mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = require("tools").quality.linters_by_ft
    end,
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
        callback = function()
          if require("tools").quality.linters_by_ft[vim.bo.filetype] then
            require("lint").try_lint()
          end
        end,
      })
    end,
  },
}
