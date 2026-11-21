return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  cmd = "BlinkCmp",
  dependencies = { "saghen/blink.lib", "ribru17/blink-cmp-spell", vim.deepcopy(require "deps.snippets") },
  build = function(plugin)
    local task = assert(require("lazy.async").running())
    ---@cast task LazyTask
    -- Neogit's ProcessOpts collides with lazy.nvim's; these options are valid for LazyTask.
    ---@diagnostic disable-next-line: missing-fields
    assert(task:spawn("cargo", {
      args = { "build", "--locked", "--release" },
      cwd = plugin.dir,
      timeout = 30 * 60 * 1000,
      on_exit = function(ok, output)
        if not ok then
          task:error(output)
        end
      end,
    }), "Blink's Rust build failed; see Cargo output above")

    local native = require "blink.lib.native"
    local extension = native.platform().lib_extension
    local target = vim.env.CARGO_TARGET_DIR or (plugin.dir .. "/target")
    if not vim.startswith(target, "/") then
      target = plugin.dir .. "/" .. target
    end
    local commit = native.git_commit(plugin.dir)
    native.mv(
      target .. "/release/libblink_cmp_fuzzy" .. extension,
      native.library_path(plugin.dir, "blink_cmp_fuzzy", commit)
    )
    vim.opt.rtp:append(plugin.dir)
    native.load("blink_cmp_fuzzy", commit)
    coroutine.yield("Rust matcher built and verified")
  end,
  opts = {
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
  },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.keymap.set("i", "<C-x><C-o>", function()
      require("blink.cmp").show()
    end, { desc = "Show completion menu" })
    vim.keymap.set("i", "<C-x><C-s>", function()
      require("blink.cmp").show { providers = { "spell" } }
    end, { desc = "Show spelling completions" })
  end,
}
