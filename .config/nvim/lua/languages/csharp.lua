local mason = require "plugins.mason"
local treesitter = require "plugins.treesitter"
local quality = require "plugins.quality"
local dap = require "plugins.debugging"

vim.pack.add {
  "https://github.com/seblyng/roslyn.nvim",
}

mason.add {
  "roslyn-language-server",
  "netcoredbg",
  "csharpier",
}

treesitter.add { "c_sharp" }

quality.formatters {
  cs = { "csharpier" },
}

dap.adapters.coreclr = {
  type = "executable",
  command = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin", "netcoredbg"),
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  },
}
