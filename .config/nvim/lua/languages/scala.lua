local quality = require "plugins.quality"
local treesitter = require "plugins.treesitter"

vim.pack.add {
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
