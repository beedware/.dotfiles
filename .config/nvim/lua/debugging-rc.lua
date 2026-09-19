vim.pack.add {
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
}

local dap = require "dap"

vim.fn.sign_define("DapStopped", { text = "> ", texthl = "SignColumn", linehl = "debugPC" })

require("dap-view").setup {
  winbar = {
    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
    default_section = "scopes",
    controls = { enabled = true },
  },
  windows = {
    terminal = {
      size = 0.40,
      position = "right",
      hide = { "delve" },
    },
  },
  auto_toggle = true,
}

vim.keymap.set("n", "<Right>", function()
  dap.step_into()
end, { desc = "Debug: step into" })
vim.keymap.set("n", "<Down>", function()
  dap.step_over()
end, { desc = "Debug: step over" })
vim.keymap.set("n", "<Left>", function()
  dap.step_out()
end, { desc = "Debug: step out" })
vim.keymap.set("n", "<Up>", function()
  dap.restart_frame()
end, { desc = "Debug: restart frame" })
vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "Debug: toggle breakpoint" })
vim.keymap.set("n", "<leader>dr", function()
  dap.continue()
end, { desc = "Debug: run or continue" })
vim.keymap.set("n", "<leader>dR", function()
  dap.restart()
end, { desc = "Debug: restart session" })
vim.keymap.set("n", "<leader>dl", function()
  dap.run_last()
end, { desc = "Debug: run last configuration" })
vim.keymap.set("n", "<leader>dt", function()
  dap.terminate()
end, { desc = "Debug: terminate session" })
vim.keymap.set("n", "<leader>dw", function()
  require("dap-view").add_expr()
end, { desc = "Debug: add watch expression" })
vim.keymap.set("n", "<leader>dk", function()
  require("dap-view").hover()
end, { desc = "Debug: hover value" })
vim.keymap.set("n", "<leader>dv", function()
  require("dap-view").virtual_text_toggle()
end, { desc = "Debug: toggle virtual text" })

return dap
