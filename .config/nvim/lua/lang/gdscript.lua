local quality = require("tools").quality

require("tools").lsp.enable { "gdscript" }
require("tools").mason.add { "gdtoolkit" }

require("tools").treesitter.add { "gdscript" }

quality.formatters {
  gdscript = { "gdformat" },
}

quality.linters {
  gdscript = { "gdlint" },
}

require("tools").debugging.configure(function(dap)
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
