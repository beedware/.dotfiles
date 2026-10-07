local quality = require "quality-rc"
local treesitter = require "treesitter-rc"

vim.pack.add {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/scalameta/nvim-metals",
}

treesitter.add { "scala" }

quality.formatters {
  scala = { "scalafmt" },
  sbt = { "scalafmt" },
}

local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "off"

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NvimMetals", { clear = true }),
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
})
