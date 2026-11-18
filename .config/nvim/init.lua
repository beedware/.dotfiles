vim.g.mapleader = " "

require "options"
require "commands"
require "autocmds"
require "keymaps"

require("vim._core.ui2").enable {}
vim.cmd.packadd "nvim.undotree"
require "plugins.theme"
require "plugins.mini"
require "plugins.git"
require "plugins.filebrowser"
require "plugins.completion"
require "plugins.documentation"
require "plugins.navigation"
require "plugins.mason"

require "languages.lua"
require "languages.vim"
require "languages.query"
require "languages.markdown"
require "languages.yaml"
require "languages.shell"

require "languages.python"
require "languages.c"
require "languages.haskell"
require "languages.prolog"
require "languages.typst"
require "languages.gdscript"
require "languages.web"
require "languages.scala"
require "languages.tex"
require "languages.nusmv"
-- require("languages.flutter")
-- require("languages.csharp")
-- require("languages.java")
-- require("languages.groovy")
