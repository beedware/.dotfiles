local has_rg = vim.fn.executable "rg" == 1

vim.api.nvim_create_user_command("Setup", function()
  local headless = #vim.api.nvim_list_uis() == 0
  local ok, err = xpcall(function()
    local lazy = require "lazy"
    local function check_plugins()
      for name, plugin in pairs(require("lazy.core.config").plugins) do
        for _, task in ipairs(plugin._.tasks or {}) do
          assert(not task:has_errors(), "Plugin setup failed for " .. name .. ": " .. task:output())
        end
      end
    end

    print "[Setup] Installing missing plugins"
    lazy.install { wait = true, show = false, lockfile = true }
    check_plugins()
    print "[Setup] Restoring locked plugins and running builds"
    lazy.restore { wait = true, show = false }
    check_plugins()

    print "[Setup] Installing Treesitter parsers"
    vim.cmd "TSInstallAll!"

    print "[Setup] Installing Mason packages"
    local packages = require("tools").mason.packages
    if #packages > 0 then
      -- Mason's headless installer streams output and waits for all packages.
      vim.cmd.MasonInstall(packages)
    end
    print "[Setup] Setup complete"
  end, debug.traceback)

  if not ok then
    if headless then
      vim.api.nvim_err_writeln(err)
      vim.cmd "cquit 1"
    else
      error(err)
    end
  end
end, { desc = "Install locked plugins, Treesitter parsers, and Mason packages" })

local function rg_find(query, no_ignore, complete)
  local pattern = vim.pesc(query:gsub("\\", "/")) .. (complete and ".*" or "")
  return vim.tbl_filter(
    function(file)
      return file:match(pattern) or vim.fs.basename(file):match(pattern)
    end,
    vim.fn.systemlist {
      "rg",
      "--files",
      "--hidden",
      no_ignore and "--no-ignore" or "--glob",
      no_ignore and "--glob" or "!.git",
      no_ignore and "!.git" or nil,
    }
  )
end

if has_rg then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git'"
  vim.o.grepformat = "%f:%l:%c:%m"
  vim.o.findfunc = "v:lua.RgFindFiles"
  function _G.RgFindFiles(cmdarg, cmdcomplete)
    return rg_find(cmdarg, false, cmdcomplete)
  end
end

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
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden --no-ignore --glob '!.git'"
  local ok, err = pcall(vim.cmd.grep, { args = { args.args }, bang = true })
  vim.o.grepprg = old_grepprg
  if not ok then
    error(err)
  end
end or need_rg "GrepAll", { complete = rg_find_all_complete, desc = "Grep including gitignored files", nargs = "+" })
