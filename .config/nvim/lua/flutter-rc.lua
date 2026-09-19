local lsp = require "lsp-rc"
local quality = require "quality-rc"
local treesitter = require "treesitter-rc"
local dap = require "debugging-rc"
local dart = vim.fn.exepath "dart" ~= "" and vim.fn.exepath "dart" or "dart"
local flutter = vim.fn.exepath "flutter" ~= "" and vim.fn.exepath "flutter" or "flutter"
local flutter_realpath = vim.uv.fs_realpath(flutter) or flutter
local flutter_root = vim.fn.fnamemodify(flutter_realpath, ":h:h")
local flutter_dart = vim.fs.joinpath(flutter_root, "bin", "cache", "dart-sdk", "bin", "dart")
local dart_sdk = vim.fn.executable(flutter_dart) == 1 and flutter_dart or dart

lsp.enable { "dartls" }

treesitter.add { "dart" }

quality.formatters {
  dart = { "dart_format" },
}

dap.adapters.dart = {
  type = "executable",
  command = dart,
  args = { "debug_adapter" },
  options = {
    detached = false,
  },
}

dap.adapters.flutter = {
  type = "executable",
  command = flutter,
  args = { "debug_adapter" },
  options = {
    detached = false,
  },
}

dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch dart",
    dartSdkPath = dart_sdk,
    flutterSdkPath = flutter,
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch flutter",
    dartSdkPath = dart_sdk,
    flutterSdkPath = flutter,
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
  },
}
