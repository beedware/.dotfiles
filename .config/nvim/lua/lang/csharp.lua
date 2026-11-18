local mason = require("tools").mason
local treesitter = require("tools").treesitter
local quality = require("tools").quality
local dap = require("tools").debugging

mason.add {
  "roslyn-language-server",
  "netcoredbg",
  "csharpier",
}

treesitter.add { "c_sharp" }

quality.formatters {
  cs = { "csharpier" },
}

dap.configure(function(dap)
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
end)

return { "seblyng/roslyn.nvim", ft = "cs" }
