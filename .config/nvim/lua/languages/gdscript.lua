local lsp = require "plugins.lsp"
local mason = require "plugins.mason"
local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"
local dap = require "plugins.debugging"

lsp.enable { "gdscript" }
mason.add { "gdtoolkit" }

treesitter.add { "gdscript" }

quality.formatters {
  gdscript = { "gdformat" },
}

quality.linters {
  gdscript = { "gdlint" },
}

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
