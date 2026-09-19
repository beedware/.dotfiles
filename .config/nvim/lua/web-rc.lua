local lsp = require "lsp-rc"
local mason = require "mason-rc"
local quality = require "quality-rc"
local treesitter = require "treesitter-rc"
local dap = require "debugging-rc"

lsp.enable {
  "biome",
  "ts_ls",
  "tailwindcss",
  "svelte",
  "jsonls",
}

mason.add {
  "biome",
  "typescript-language-server",
  "tailwindcss-language-server",
  "svelte-language-server",
  "js-debug-adapter",
  "firefox-debug-adapter",
  "prettierd",
  "json-lsp",
}

treesitter.add {
  "css",
  "htmldjango",
  "html",
  "javascript",
  "json",
  "svelte",
  "tsx",
  "typescript",
}

quality.formatters {
  typescript = { "biome" },
  typescriptreact = { "biome" },
  javascript = { "biome" },
  javascriptreact = { "biome" },
  json = { "biome" },
  html = { "biome" },
  css = { "biome" },
  svelte = { "biome" },
}

quality.linters {
  typescript = { "biomejs" },
  typescriptreact = { "biomejs" },
  javascript = { "biomejs" },
  javascriptreact = { "biomejs" },
  json = { "biomejs" },
  html = { "biomejs" },
  css = { "biomejs" },
  svelte = { "biomejs" },
}

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin", "js-debug-adapter"),
    args = { "${port}" },
  },
}

dap.adapters.firefox = {
  type = "executable",
  command = "node",
  args = {
    vim.fs.joinpath(vim.fn.stdpath "data", "mason", "packages", "firefox-debug-adapter", "dist", "adapter.bundle.js"),
  },
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
  {
    type = "firefox",
    request = "launch",
    name = "Launch browser",
    reAttach = true,
    url = function()
      local host = vim.fn.input "Host [localhost]: "
      local port = vim.fn.input "Port [3000]: "
      return "http://" .. (host ~= "" and host or "localhost") .. ":" .. (port ~= "" and port or "3000")
    end,
    webRoot = "${workspaceFolder}",
    firefoxExecutable = vim.fn.exepath "firefox" ~= "" and vim.fn.exepath "firefox" or "firefox",
  },
}

dap.configurations.javascriptreact = dap.configurations.javascript
dap.configurations.typescript = dap.configurations.javascript
dap.configurations.typescriptreact = dap.configurations.javascript
dap.configurations.svelte = dap.configurations.javascript
