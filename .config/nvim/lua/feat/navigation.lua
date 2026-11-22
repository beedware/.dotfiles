return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function()
      return {
        { "hide" },
        defaults = {
          file_icons = false,
          git_icons = false,
          color_icons = false,
        },
        fzf_colors = true,
        keymap = {
          fzf = {
            true,
            ["ctrl-q"] = "select-all+accept",
          },
        },
        actions = {
          files = {
            true,
            ["ctrl-x"] = require("fzf-lua").actions.file_split,
          },
        },
        winopts = {
          split = "botright 14new",
          preview = { hidden = true },
        },
        files = {
          cwd_prompt = false,
        },
        oldfiles = {
          cwd_only = true,
        },
        lsp = {
          path_shorten = 1,
          document_symbols = {
            symbol_style = 2,
            symbol_icons = {
              File = "Fi",
              Module = "Mo",
              Namespace = "N",
              Package = "P",
              Class = "Cl",
              Method = "M",
              Property = "P",
              Field = "Fd",
              Constructor = "C",
              Enum = "E",
              Interface = "I",
              Function = "F",
              Variable = "V",
              Constant = "Co",
              String = "T",
              Number = "N",
              Boolean = "B",
              Array = "A",
              Object = "O",
              Key = "K",
              Null = "Nil",
              EnumMember = "Em",
              Struct = "St",
              Event = "Ev",
              Operator = "Op",
              TypeParameter = "Tp",
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>fa", "<cmd>FzfLua files<cr>", desc = "Find all files" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Find recent files in current directory" },
      { "<leader>ff", "<cmd>FzfLua files hidden=false<cr>", desc = "Find files" },
      { "<leader>fw", "<cmd>FzfLua live_grep<cr>", desc = "Find in project" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Find help tags" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymaps" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Find marks" },
      { "<leader>fz", "<cmd>FzfLua blines<cr>", desc = "Search current buffer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttachMappings", { clear = true }),
        callback = function(args)
          vim.keymap.set("n", "grr", function()
            require("fzf-lua").lsp_references()
          end, { buffer = args.buf, desc = "LSP: find references" })
          vim.keymap.set("n", "gri", function()
            require("fzf-lua").lsp_implementations()
          end, { buffer = args.buf, desc = "LSP: find implementations" })
          vim.keymap.set("n", "grt", function()
            require("fzf-lua").lsp_typedefs()
          end, { buffer = args.buf, desc = "LSP: type definitions" })
          vim.keymap.set("n", "gO", function()
            require("fzf-lua").lsp_document_symbols()
          end, { buffer = args.buf, desc = "LSP: document symbols" })
          vim.keymap.set("n", "gd", function()
            require("fzf-lua").lsp_definitions()
          end, { buffer = args.buf, desc = "Go to definition" })
        end,
      })
    end,
  },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand { before = 2, after = 2, add_to_existing = true }
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
      type_icons = {
        E = "E ",
        W = "W ",
        I = "I ",
        N = "N ",
        H = "H ",
      },
      borders = {
        vert = "|",
        strong_header = "=",
        strong_cross = "+",
        strong_end = "+",
        soft_header = "-",
        soft_cross = "+",
        soft_end = "+",
      },
    },
  },
}
