return {
  "nvim-mini/mini.nvim",
  lazy = false,
  config = function()
    require("mini.sessions").setup {
      force = { read = false, write = true, delete = true },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("MiniPatternsSetup", { clear = true }),
      once = true,
      callback = function()
        require("mini.hipatterns").setup {
          highlighters = {
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
            hex_color = require("mini.hipatterns").gen_highlighter.hex_color { style = "inline", inline_text = "█ " },
          },
        }
      end,
    })
  end,
}
