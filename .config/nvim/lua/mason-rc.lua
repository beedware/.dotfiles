vim.pack.add {
  "https://github.com/mason-org/mason.nvim",
}

local M = {}
local packages = {}

require("mason").setup {
  PATH = "skip",
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
  ui = {
    backdrop = 100,
    icons = {
      package_pending = "[.] ",
      package_installed = "[+] ",
      package_uninstalled = "[ ] ",
    },
  },
  max_concurrent_installers = 10,
}

function M.add(items)
  vim.list_extend(packages, items)
end

vim.api.nvim_create_user_command("MasonInstallAll", function()
  require("mason-registry").refresh(function()
    for _, name in ipairs(packages) do
      if
        pcall(require("mason-registry").get_package, name)
        and not select(2, pcall(require("mason-registry").get_package, name)):is_installed()
      then
        select(2, pcall(require("mason-registry").get_package, name)):install()
      end
    end
  end)
  vim.cmd "Mason"
end, {
  desc = "Install enabled Mason packages",
})

vim.api.nvim_create_user_command("MasonClean", function(args)
  require("mason-registry").refresh(function()
    local enabled = {}
    for _, name in ipairs(packages) do
      enabled[name] = true
    end

    local unused = {}
    for _, package in ipairs(require("mason-registry").get_installed_packages()) do
      local name = package.name
      if not enabled[name] then
        table.insert(unused, name)
      end
    end

    if vim.tbl_isempty(unused) then
      vim.notify "No unused Mason packages found"
      return
    end

    if not args.bang then
      vim.notify("Unused Mason packages: " .. table.concat(unused, ", ") .. "\nRun :MasonClean! to uninstall them")
      return
    end

    for _, name in ipairs(unused) do
      require("mason-registry").get_package(name):uninstall()
    end
  end)
end, {
  bang = true,
  desc = "Uninstall Mason packages that are not enabled",
})

return M
