vim.pack.add({
  { src = "https://github.com/folke/lazy.nvim", version = "stable" },
}, { load = true })

local M = {}

function M.setup(specs)
  require("lazy").setup(specs, {
    defaults = { lazy = true, version = false },
    pkg = { enabled = false },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { "modus" } },
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
