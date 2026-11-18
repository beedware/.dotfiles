local lsp = require("tools").lsp
local mason = require("tools").mason
local quality = require("tools").quality
local treesitter = require("tools").treesitter
local dap = require("tools").debugging

lsp.enable { "gdscript" }
mason.add { "gdtoolkit" }

treesitter.add { "gdscript" }

quality.formatters {
  gdscript = { "gdformat" },
}

quality.linters {
  gdscript = { "gdlint" },
}

dap.configure(function(dap)
  dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006,
  }

  dap.configurations.gdscript = {
    {
      type = "godot",
      request = "launch",
      name = "Launch scene",
      project = "${workspaceFolder}",
    },
  }
end)

return {}
