require("tools").treesitter.add { "scala" }

require("tools").quality.formatters {
  scala = { "scalafmt" },
  sbt = { "scalafmt" },
}

return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt" },
  config = function()
    vim.opt_global.shortmess:remove "F"
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
