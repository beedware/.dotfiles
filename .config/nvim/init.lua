vim.g.mapleader = " "

require "options"
require "commands"
require "autocmds"
require "keymaps"

require("vim._core.ui2").enable {}
vim.cmd.packadd "nvim.undotree"
vim.cmd.packadd "nvim.difftool"

require("deps.lazy").setup {
  require "feat.theme",
  require "feat.mini",
  require "feat.git",
  require "feat.filebrowser",
  require "feat.completion",
  require "feat.documentation",
  require "feat.navigation",
  require "feat.mason",
  require "feat.lsp",
  require "feat.quality",
  require "feat.treesitter",
  require "feat.debugging",

  require "lang.lua",
  require "lang.vim",
  require "lang.query",
  require "lang.markdown",
  require "lang.yaml",
  require "lang.shell",
  require "lang.python",
  require "lang.c",
  require "lang.haskell",
  require "lang.prolog",
  require "lang.typst",
  require "lang.gdscript",
  require "lang.web",
  require "lang.scala",
  require "lang.tex",
  require "lang.nusmv",
  -- require "lang.flutter",
  -- require "lang.csharp",
  -- require "lang.java",
  -- require "lang.groovy",
}
