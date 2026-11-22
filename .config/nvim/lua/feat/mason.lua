local packages = require("tools").mason.packages

return {
  "mason-org/mason.nvim",
  lazy = false,
  opts = {
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
  },
  init = function()
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      local registry = require "mason-registry"
      local missing = vim.tbl_filter(function(name)
        return not registry.is_installed(name)
      end, packages)
      if #missing > 0 then
        vim.cmd.MasonInstall(missing)
      else
        vim.cmd.Mason()
      end
    end, {
      desc = "Install enabled Mason packages",
    })

    vim.api.nvim_create_user_command("MasonClean", function(args)
      local registry = require "mason-registry"
      local unused = vim.tbl_filter(function(name)
        return not vim.list_contains(packages, name)
      end, registry.get_installed_package_names())
      table.sort(unused)
      if #unused == 0 then
        vim.notify "No unused Mason packages found"
      elseif args.bang then
        registry.refresh(function()
          vim.cmd.MasonUninstall(unused)
        end)
      else
        vim.notify("Unused Mason packages: " .. table.concat(unused, ", ") .. "\nRun :MasonClean! to uninstall them")
      end
    end, {
      bang = true,
      desc = "Uninstall Mason packages that are not enabled",
    })
  end,
}
