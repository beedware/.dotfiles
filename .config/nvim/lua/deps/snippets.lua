return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require "luasnip"
    ls.setup {
      keep_roots = true,
      link_roots = true,
      link_children = true,
      exit_roots = false,
      update_events = { "TextChanged", "TextChangedI" },
    }
    local watch = { autocmd = true, libuv = true }
    require("luasnip.loaders.from_vscode").lazy_load { fs_event_providers = watch }
    for loader, directory in pairs { vscode = "vscode", snipmate = "snipmate", lua = "luasnips" } do
      require("luasnip.loaders.from_" .. loader).lazy_load {
        paths = { vim.fs.joinpath(vim.fn.stdpath "config", directory) },
        fs_event_providers = watch,
      }
    end
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = vim.api.nvim_create_augroup("LuasnipCleanup", { clear = true }),
      callback = function()
        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
          ls.unlink_current()
        end
      end,
    })
  end,
}
