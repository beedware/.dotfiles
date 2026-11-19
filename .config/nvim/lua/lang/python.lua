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

require("tools").documentation.languages {
  python = function()
    local template = require("neogen.types.template").item
    return {
      template = {
        annotation_convention = "google_docstrings",
        sphinx = {
          { nil, '"""$1"""', { no_results = true, type = { "class", "func" } } },
          { nil, '"""$1', { no_results = true, type = { "file" } } },
          { nil, "", { no_results = true, type = { "file" } } },
          { nil, "$1", { no_results = true, type = { "file" } } },
          { nil, '"""', { no_results = true, type = { "file" } } },
          { nil, "", { no_results = true, type = { "file" } } },
          { nil, "# $1", { no_results = true, type = { "type" } } },
          { nil, '"""$1' },
          { nil, "" },
          {
            template.Parameter,
            ":param %s: $1",
            { after_each = ":type %s: $1", type = { "func" } },
          },
          {
            { template.Parameter, template.Type },
            ":param %s %s: $1",
            { required = template.Tparam, type = { "func" } },
          },
          { template.ClassAttribute, ":ivar %s: $1" },
          { template.Throw, ":raises %s: $1", { type = { "func" } } },
          {
            template.Return,
            ":returns: $1",
            { after_each = ":rtype: $1", type = { "func" } },
          },
          {
            template.ReturnTypeHint,
            ":returns: $1",
            { after_each = ":rtype: %s", type = { "func" } },
          },
          { nil, '"""' },
        },
      },
    }
  end,
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
