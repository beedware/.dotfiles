local mason = require "plugins.mason"
local treesitter = require "plugins.treesitter"

vim.pack.add {
  "https://codeberg.org/mfussenegger/nvim-jdtls",
}

mason.add {
  "jdtls",
  "java-debug-adapter",
  "java-test",
}

treesitter.add { "java" }
