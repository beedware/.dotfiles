return {
  url = "https://codeberg.org/mfussenegger/nvim-dap",
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
      version = "1.*",
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
      opts = {
        winbar = {
          default_section = "scopes",
          controls = { enabled = true },
        },
        windows = { terminal = { size = 0.40, position = "right", hide = { "delve" } } },
        auto_toggle = true,
      },
      config = function(_, opts)
        local dap = require "dap"
        local exceptions = require "dap-view.exceptions"
        local sync_filters = exceptions.update_exception_breakpoints_filters
        rawset(exceptions, "update_exception_breakpoints_filters", function()
          local session = dap.session()
          if session and session.config.type == "haskell-debugger" and not session.stopped_thread_id then
            return
          end
          coroutine.wrap(sync_filters)()
        end)
        require("dap-view").setup(opts)
      end,
    },
  },
  keys = {
    { "<Right>", "<cmd>DapStepInto<cr>", desc = "Debug: step into" },
    { "<Down>", "<cmd>DapStepOver<cr>", desc = "Debug: step over" },
    { "<Left>", "<cmd>DapStepOut<cr>", desc = "Debug: step out" },
    { "<Up>", "<cmd>DapRestartFrame<cr>", desc = "Debug: restart frame" },
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Debug: toggle breakpoint" },
    { "<leader>dr", "<cmd>DapContinue<cr>", desc = "Debug: run or continue" },
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
    { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Debug: terminate session" },
    { "<leader>dw", "<cmd>DapViewWatch<cr>", desc = "Debug: add watch expression" },
    { "<leader>dk", "<cmd>DapViewHover<cr>", desc = "Debug: hover value" },
    { "<leader>dv", "<cmd>DapViewVirtualTextToggle<cr>", desc = "Debug: toggle virtual text" },
  },
  config = function()
    local dap = require "dap"
    vim.fn.sign_define("DapStopped", { text = "> ", texthl = "SignColumn", linehl = "debugPC" })
    for _, configure in ipairs(require("tools").debugging.configurations) do
      configure(dap)
    end
  end,
}
