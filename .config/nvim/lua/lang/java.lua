local mason = require("tools").mason
local treesitter = require("tools").treesitter

mason.add {
  "jdtls",
  "java-debug-adapter",
  "java-test",
}

treesitter.add { "java" }

return { url = "https://codeberg.org/mfussenegger/nvim-jdtls", ft = "java" }
