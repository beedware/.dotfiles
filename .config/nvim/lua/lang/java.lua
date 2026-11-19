require("tools").mason.add {
  "jdtls",
  "java-debug-adapter",
  "java-test",
}

require("tools").treesitter.add { "java" }

return { url = "https://codeberg.org/mfussenegger/nvim-jdtls", ft = "java" }
