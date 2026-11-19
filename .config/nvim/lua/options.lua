vim.o.spellfile = vim.fs.joinpath(vim.fn.stdpath "config", "spell", "en.utf-8.add")

local mode_file = io.open(vim.fn.expand "~/.config/themer/mode", "r")
local mode = mode_file and mode_file:read "*a" or "dark"
if mode_file then
  mode_file:close()
end
vim.o.background = vim.trim(mode) == "light" and "light" or "dark"

vim.o.splitkeep = "screen"

vim.o.cursorline = true
vim.o.completeopt = "menu,popup,noselect"

vim.o.expandtab = true
vim.o.smartindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2

vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.undodir = vim.fs.joinpath(vim.fn.stdpath "data", "undodir")

vim.o.foldmethod = "manual"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldtext = "v:folddashes . substitute(getline(v:foldstart), '/\\*\\|\\*/\\|{{{\\d\\=', '', 'g')"

vim.o.updatetime = 250

vim.opt.listchars = { tab = "> ", nbsp = "+", space = ".", trail = "-" }

vim.opt.fillchars = { eob = " " }
vim.opt.guicursor = ""
vim.opt.shortmess:append "sI"
vim.opt.wrap = false

vim.opt.whichwrap:append "<>[]hl"

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.netrw_banner = 0
