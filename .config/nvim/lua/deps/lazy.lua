local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local M = {}

function M.setup(specs)
  require("lazy").setup(specs, {
    defaults = { lazy = true, version = false },
    pkg = { enabled = false },
    checker = { enabled = false },
    change_detection = { notify = false },
    ui = {
      icons = {
        cmd = ": ",
        config = "[cfg] ",
        debug = "[dbg] ",
        event = "[evt] ",
        favorite = "* ",
        ft = "[ft] ",
        init = "[init] ",
        import = "[imp] ",
        keys = "[key] ",
        lazy = "[lazy] ",
        loaded = "[X]",
        not_loaded = "[ ]",
        plugin = "[pkg] ",
        runtime = "[rtp] ",
        require = "[req] ",
        source = "[src] ",
        start = "> ",
        task = "[.] ",
        list = { "-", ">", "*", "+" },
      },
    },
    performance = { rtp = { disabled_plugins = { "netrwPlugin" } } },
  })
end

return M
