vim.pack.add {
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/quicker.nvim",
}

require("fzf-lua").setup {
  { "hide" },
  defaults = {
    file_icons = false,
    git_icons = false,
    color_icons = false,
  },
  fzf_colors = true,
  fzf_opts = {
    ["--layout"] = "reverse",
  },
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
  ---@diagnostic disable-next-line: assign-type-mismatch
  winopts = function()
    return {
      split = ("botright %dnew"):format(14),
      height = 14,
      preview = {
        hidden = true,
      },
    }
  end,
  files = {
    cwd_prompt = false,
  },
  oldfiles = {
    cwd_only = true,
  },
  lsp = {
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

require("quicker").setup {
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
}

vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua files<CR>", { desc = "Find all files" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", { desc = "Find recent files in current directory" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files hidden=false<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find in project" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "Find marks" })
vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua blines<CR>", { desc = "Search current buffer" })

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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("OilFzfLocalFiles", { clear = true }),
  pattern = "oil",
  callback = function(args)
    vim.keymap.set("n", "<leader>ff", function()
      require("fzf-lua").files { cwd = require("oil").get_current_dir() or vim.fn.getcwd() }
    end, { buffer = args.buf, desc = "Find files in the current directory" })
  end,
})
