vim.pack.add {
  "https://github.com/nvim-mini/mini.nvim",
}

require("mini.sessions").setup {
  force = { read = false, write = true, delete = true },
}

require("mini.hipatterns").setup {
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color { style = "inline", inline_text = "█ " },
  },
}
