vim.g.mapleader = " "

require("vim._core.ui2").enable {}
vim.cmd.packadd "nvim.undotree"

require "theme-rc"
require "mini-rc"
require "git-rc"
require "journal-rc"
require "filebrowser-rc"
require "completion-rc"
require "documentation-rc"
require "navigation-rc"
require "mason-rc"

-- Default languages
require "lua-rc"
require "vim-rc"
require "query-rc"
require "markdown-rc"
require "yaml-rc"
require "shell-rc"

-- All Paradigm Languages
require "python-rc"
require "c-rc"
require "haskell-rc"
require "prolog-rc"
require "typst-rc"

-- Additional Languages
require "gdscript-rc"
require "web-rc"
-- require("flutter-rc")
-- require("tex-rc")
-- require("csharp-rc")
-- require("java-rc")
-- require("groovy-rc")

-- Options
vim.o.spellfile = vim.fs.joinpath(vim.fn.stdpath "config", "spell", "en.utf-8.add")

vim.o.list = true
vim.o.background = "dark"
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

vim.wo[0][0].foldmethod = "expr"
vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldtext = "v:folddashes.substitute(getline(v:foldstart),'/\\*\\|\\*/\\|{{{\\d\\=','','g')"

vim.o.updatetime = 250

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

local has_rg = vim.fn.executable "rg" == 1
local rg_grep = "rg --vimgrep --smart-case --hidden --glob '!.git'"
local rg_grep_all = "rg --vimgrep --smart-case --hidden --no-ignore --glob '!.git'"

local function rg_find(query, no_ignore, complete)
  local files = vim.fn.systemlist {
    "rg",
    "--files",
    "--hidden",
    no_ignore and "--no-ignore" or "--glob",
    no_ignore and "--glob" or "!.git",
    no_ignore and "!.git" or nil,
  }
  local pattern = vim.pesc(query:gsub("\\", "/")) .. (complete and ".*" or "")
  return vim.tbl_filter(function(file)
    return file:match(pattern) or vim.fs.basename(file):match(pattern)
  end, files)
end

if has_rg then
  vim.o.grepprg = rg_grep
  vim.o.grepformat = "%f:%l:%c:%m"
  vim.o.findfunc = "v:lua.RgFindFiles"
  function _G.RgFindFiles(cmdarg, cmdcomplete)
    return rg_find(cmdarg, false, cmdcomplete)
  end
end

-- Commands
local function need_rg(name)
  return function()
    vim.notify(name .. " requires ripgrep", vim.log.levels.WARN)
  end
end

local rg_find_all_complete = has_rg and function(arglead)
  return rg_find(arglead, true, true)
end or "file"

vim.api.nvim_create_user_command("FindAll", has_rg and function(args)
  local matches = rg_find(args.args, true)
  if vim.tbl_isempty(matches) then
    return vim.notify("No files found matching: " .. args.args, vim.log.levels.WARN)
  end
  vim.cmd.edit(vim.fn.fnameescape(matches[1]))
end or need_rg "FindAll", { complete = rg_find_all_complete, desc = "Find file including gitignored files", nargs = 1 })

vim.api.nvim_create_user_command("GrepAll", has_rg and function(args)
  local old_grepprg = vim.o.grepprg
  vim.o.grepprg = rg_grep_all
  local ok, err = pcall(vim.cmd.grep, { args = { args.args }, bang = true })
  vim.o.grepprg = old_grepprg
  if not ok then
    error(err)
  end
end or need_rg "GrepAll", { complete = rg_find_all_complete, desc = "Grep including gitignored files", nargs = "+" })

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, {
  desc = "Update vim.pack plugins",
})

vim.api.nvim_create_user_command("PackClean", function(args)
  local unused = {}
  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active and plugin.spec.name then
      table.insert(unused, plugin.spec.name)
    end
  end

  if vim.tbl_isempty(unused) then
    vim.notify "No unused packages found"
    return
  end

  if not args.bang then
    vim.notify("Unused packages: " .. table.concat(unused, ", ") .. "\nRun :PackClean! to uninstall them")
    return
  end

  vim.pack.del(unused)
end, {
  bang = true,
  desc = "Uninstall inactive vim.pack packages",
})

-- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("DotenvFt", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("OpenBinaryExternally", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" or path:match "^%w+://" then
      return
    end
    local opener_ext = {
      png = true,
      jpg = true,
      jpeg = true,
      gif = true,
      webp = true,
      svg = true,
      bmp = true,
      ico = true,
      pdf = true,
      mp4 = true,
      mkv = true,
      mov = true,
      avi = true,
      webm = true,
      mp3 = true,
      wav = true,
      flac = true,
      ogg = true,
    }
    if not opener_ext[vim.fn.fnamemodify(path, ":e"):lower()] then
      return
    end
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
    vim.schedule(function()
      if vim.api.nvim_get_current_buf() ~= args.buf then
        return
      end
      pcall(vim.cmd, "silent! b#")
      if vim.api.nvim_get_current_buf() == args.buf then
        pcall(vim.cmd, "silent! enew")
      end
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("AutoResizeSplits", { clear = true }),
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("ToggleListchars", { clear = true }),
  callback = function()
    vim.opt_local.listchars = { tab = "> ", nbsp = "+" }
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("ToggleListchars", { clear = false }),
  callback = function()
    vim.opt_local.listchars = { tab = "> ", nbsp = "+", trail = "-" }
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("BigFile", { clear = true }),
  callback = function(args)
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    if vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf)) <= 1024 * 1024 * 1.5 then
      return
    end
    vim.b[args.buf].bigfile = true
    vim.notify(
      ("Big file detected: %.2f MiB"):format(vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf)) / 1024 / 1024),
      vim.log.levels.WARN,
      { title = "BigFile" }
    )
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.spell = false
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("BigFile", { clear = false }),
  callback = function(args)
    if not vim.b[args.buf].bigfile then
      return
    end
    pcall(vim.treesitter.stop, args.buf)
    pcall(vim.api.nvim_buf_call, args.buf, function()
      vim.cmd.syntax "off"
    end)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("BuiltinLspMappings", { clear = true }),
  callback = function(args)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
  end,
})

-- Mappings
vim.keymap.set("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Show diagnostics in location list" })
vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, { desc = "Show all diagnostics in quickfix" })

vim.keymap.set("n", "<leader>ta", function()
  if vim.wo.arabic then
    if vim.b._arabic_toggle_manages_spell == nil then
      vim.b._arabic_toggle_manages_spell = vim.wo.spell
    end
    if vim.b._arabic_toggle_manages_spell then
      vim.cmd "set spell"
    end
    vim.cmd "set noarab"
    return
  end
  if vim.b._arabic_toggle_manages_spell == nil then
    vim.b._arabic_toggle_manages_spell = vim.wo.spell
  end
  if vim.b._arabic_toggle_manages_spell then
    vim.cmd "set nospell"
  end
  vim.cmd "set arab"
end, { desc = "Toggle Arabic" })

vim.keymap.set("i", "<C-^>", function()
  if vim.wo.arabic then
    if vim.b._arabic_toggle_manages_spell == nil then
      vim.b._arabic_toggle_manages_spell = vim.wo.spell
    end
    if vim.b._arabic_toggle_manages_spell then
      vim.cmd "set spell"
    end
    return vim.api.nvim_replace_termcodes("<C-o>:set noarab<CR>", true, false, true)
  end
  if vim.b._arabic_toggle_manages_spell == nil then
    vim.b._arabic_toggle_manages_spell = vim.wo.spell
  end
  if vim.b._arabic_toggle_manages_spell then
    vim.cmd "set nospell"
  end
  return vim.api.nvim_replace_termcodes("<C-o>:set arab<CR>", true, false, true)
end, { expr = true, desc = "Toggle Arabic" })
