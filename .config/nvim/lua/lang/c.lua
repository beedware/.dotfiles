local lsp = require("tools").lsp
local mason = require("tools").mason
local quality = require("tools").quality
local treesitter = require("tools").treesitter
local dap = require("tools").debugging

lsp.enable { "clangd" }
mason.add {
  "clangd",
  "codelldb",
  "cpplint",
  "clang-format",
}

treesitter.add { "c", "cpp" }

quality.formatters {
  c = { "clang-format" },
  cpp = { "clang-format" },
}

quality.linters {
  c = { "cpplint" },
  cpp = { "cpplint" },
}

dap.configure(function(dap)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin", "codelldb"),
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. package.config:sub(1, 1), "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      console = "integratedTerminal",
    },
    {
      name = "Launch file (args)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd(), "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        return vim.split(vim.fn.input "Args: ", " +", { trimempty = true })
      end,
      console = "integratedTerminal",
    },
  }

  dap.configurations.c = dap.configurations.cpp
end)

return {}
