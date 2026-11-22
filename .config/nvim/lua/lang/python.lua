local quality = require("tools").quality

require("tools").lsp.enable { "ty" }
require("tools").mason.add {
  "ty",
  "debugpy",
  "ruff",
  "djlint",
}

require("tools").treesitter.add { "python" }

quality.formatters {
  python = { "ruff_format", "ruff_organize_imports" },
  djangohtml = { "djlint" },
  htmldjango = { "djlint" },
}

quality.linters {
  python = { "ruff" },
  htmldjango = { "djlint" },
}

require("tools").debugging.configure(function()
  require("dap-python").setup(
    vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "debugpy", "venv", "bin", "python")
  )
end)

return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = { { url = "https://codeberg.org/mfussenegger/nvim-dap-python" } },
}
