return {
  "mfussenegger/nvim-dap",
  cmd = {
    "DapSetLogLevel",
    "DapShowLog",
    "DapContinue",
    "DapToggleBreakpoint",
    "DapClearBreakpoints",
    "DapToggleRepl",
    "DapStepOver",
    "DapStepInto",
    "DapStepOut",
    "DapPause",
    "DapTerminate",
    "DapDisconnect",
    "DapRestartFrame",
    "DapNew",
    "DapEval",
  },
  dependencies = {
    {
      "igorlfs/nvim-dap-view",
      cmd = {
        "DapViewOpen",
        "DapViewClose",
        "DapViewHover",
        "DapViewToggle",
        "DapViewVirtualTextEnable",
        "DapViewVirtualTextDisable",
        "DapViewVirtualTextToggle",
        "DapViewWatch",
        "DapViewJump",
        "DapViewShow",
        "DapViewNavigate",
      },
      config = function()
        require "dap"
        require("dap-view").setup {
          winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
            default_section = "scopes",
            controls = { enabled = true },
          },
          windows = { terminal = { size = 0.40, position = "right", hide = { "delve" } } },
          auto_toggle = true,
        }
      end,
    },
  },
  keys = {
    {
      "<Right>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: step into",
    },
    {
      "<Down>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: step over",
    },
    {
      "<Left>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: step out",
    },
    {
      "<Up>",
      function()
        require("dap").restart_frame()
      end,
      desc = "Debug: restart frame",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: toggle breakpoint",
    },
    {
      "<leader>dr",
      function()
        require("dap").continue()
      end,
      desc = "Debug: run or continue",
    },
    {
      "<leader>dR",
      function()
        require("dap").restart()
      end,
      desc = "Debug: restart session",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: run last configuration",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Debug: terminate session",
    },
    {
      "<leader>dw",
      function()
        require "dap"
        require("dap-view").add_expr()
      end,
      desc = "Debug: add watch expression",
    },
    {
      "<leader>dk",
      function()
        require "dap"
        require("dap-view").hover()
      end,
      desc = "Debug: hover value",
    },
    {
      "<leader>dv",
      function()
        require "dap"
        require("dap-view").virtual_text_toggle()
      end,
      desc = "Debug: toggle virtual text",
    },
  },
  config = function()
    local dap = require "dap"
    vim.fn.sign_define("DapStopped", { text = "> ", texthl = "SignColumn", linehl = "debugPC" })
    for _, configure in ipairs(require("tools").debugging.configurations) do
      configure(dap)
    end
  end,
}
