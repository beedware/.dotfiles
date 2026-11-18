local quality = require("tools").quality
local treesitter = require("tools").treesitter

treesitter.add { "scala" }

quality.formatters {
  scala = { "scalafmt" },
  sbt = { "scalafmt" },
}

return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt" },
  config = function()
    local config = require("metals").bare_config()
    config.init_options.statusBarProvider = "off"
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvimMetals", { clear = true }),
      pattern = { "scala", "sbt" },
      callback = function()
        require("metals").initialize_or_attach(config)
      end,
    })
  end,
}
