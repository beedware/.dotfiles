vim.pack.add {
  "https://github.com/saghen/blink.cmp",
  "https://github.com/saghen/blink.lib",
  "https://github.com/ribru17/blink-cmp-spell",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
}

---@diagnostic disable-next-line: undefined-field
require("blink.cmp").build():pwait()

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

require("blink.cmp").setup {
  snippets = { preset = "luasnip" },
  cmdline = {
    keymap = {
      ["<Tab>"] = { "show", "select_next" },
    },
    completion = {
      menu = {
        auto_show = false,
      },
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
  appearance = {
    nerd_font_variant = "mono",
    kind_icons = {
      Text = "[T]",
      Method = "[M]",
      Function = "[F]",
      Constructor = "[C]",
      Field = "[Fd]",
      Variable = "[V]",
      Property = "[P]",
      Class = "[Cl]",
      Interface = "[I]",
      Struct = "[St]",
      Module = "[Mo]",
      Unit = "[U]",
      Value = "[Val]",
      Enum = "[E]",
      EnumMember = "[Em]",
      Keyword = "[K]",
      Constant = "[Co]",
      Snippet = "[S]",
      Color = "[Col]",
      File = "[Fi]",
      Reference = "[R]",
      Folder = "[Dir]",
      Event = "[Ev]",
      Operator = "[Op]",
      TypeParameter = "[Tp]",
    },
  },
  fuzzy = { implementation = "prefer_rust" },
  sources = {
    default = { "lsp", "snippets", "buffer", "path" },
    providers = {
      spell = {
        name = "Spell",
        module = "blink-cmp-spell",
        opts = {
          max_entries = 20,
          keep_all_entries = true,
        },
      },
    },
  },
  keymap = {
    preset = "none",
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-y>"] = { "accept", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-j>"] = { "snippet_forward", "fallback" },
    ["<C-k>"] = { "snippet_backward", "fallback" },
  },
  completion = {
    ghost_text = { enabled = false },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "none" },
    },
    list = {
      selection = {
        preselect = false,
      },
    },
    menu = {
      auto_show = false,
    },
  },
  signature = { enabled = false },
}

vim.keymap.set("i", "<C-x><C-o>", function()
  require("blink.cmp").show()
end, { desc = "Show completion menu" })
vim.keymap.set("i", "<C-x><C-s>", function()
  require("blink.cmp").show { providers = { "spell" } }
end, { desc = "Show spelling completions" })

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("LuasnipCleanup", { clear = true }),
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})
