local lsp = require "lsp-rc"
local mason = require "mason-rc"
local quality = require "quality-rc"
local documentation = require "documentation-rc"
local treesitter = require "treesitter-rc"
require "debugging-rc"

lsp.enable { "ty" }
mason.add {
  "ty",
  "debugpy",
  "ruff",
  "djlint",
}

treesitter.add { "python" }

quality.formatters {
  python = { "ruff_format", "ruff_organize_imports" },
  djangohtml = { "djlint" },
  htmldjango = { "djlint" },
}

quality.linters {
  python = { "ruff" },
  htmldjango = { "djlint" },
}

local template = require("neogen.types.template").item

documentation.languages {
  python = {
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
  },
}

vim.pack.add {
  "https://codeberg.org/mfussenegger/nvim-dap-python",
}

local function python_executable(venv)
  if vim.fn.has "win32" == 1 then
    return vim.fs.joinpath(venv, "Scripts", "python.exe")
  end
  return vim.fs.joinpath(venv, "bin", "python")
end

require("dap-python").setup(
  python_executable(vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "debugpy", "venv"))
)
