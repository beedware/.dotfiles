vim.pack.add {
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
}

local M = {}
local formatters_by_ft = {
  ["_"] = { "trim_whitespace" },
}
local linters_by_ft = {}
local format_enabled = true

local function configure()
  require("conform").setup {
    formatters_by_ft = formatters_by_ft,
    format_on_save = format_enabled and {
      lsp_format = "never",
      formatters = { "trim_whitespace" },
    } or nil,
  }

  require("lint").linters_by_ft = linters_by_ft
end

function M.formatters(items)
  for ft, formatters in pairs(items) do
    formatters_by_ft[ft] = formatters
  end
  configure()
end

function M.linters(items)
  for ft, linters in pairs(items) do
    linters_by_ft[ft] = linters
  end
  configure()
end

configure()

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format { lsp_format = "fallback", async = true }
end, { desc = "Format code" })

vim.api.nvim_create_user_command("Format", function(opts)
  if opts.args ~= "disable" and opts.args ~= "enable" then
    vim.notify("Usage: Format {disable|enable}", vim.log.levels.ERROR)
    return
  end
  format_enabled = opts.args == "enable"
  configure()
end, {
  nargs = 1,
  complete = function()
    return { "disable", "enable" }
  end,
  desc = "Enable or disable format on save",
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})

return M
