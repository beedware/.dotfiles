return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip").config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
    require("luasnip.loaders.from_vscode").lazy_load {
      exclude = {},
      fs_event_providers = { autocmd = true, libuv = true },
    }
    require("luasnip.loaders.from_vscode").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "vscode") },
      fs_event_providers = { autocmd = true, libuv = true },
    }
    require("luasnip.loaders.from_snipmate").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "snipmate") },
      fs_event_providers = { autocmd = true, libuv = true },
    }
    require("luasnip.loaders.from_lua").lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath "config", "luasnips") },
      fs_event_providers = { autocmd = true, libuv = true },
    }
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = vim.api.nvim_create_augroup("LuasnipCleanup", { clear = true }),
      callback = function()
        local ls = require "luasnip"
        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
          ls.unlink_current()
        end
      end,
    })
  end,
}
