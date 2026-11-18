local packages = require("tools").mason.packages

local function setup()
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
end

local function init()
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    require("mason-registry").refresh(function()
      for _, name in ipairs(packages) do
        local ok, package = pcall(require("mason-registry").get_package, name)
        if ok and not package:is_installed() then
          package:install()
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
end

return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
  init = init,
  config = setup,
}
