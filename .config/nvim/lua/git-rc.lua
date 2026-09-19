vim.cmd.packadd "nvim.difftool"

vim.pack.add {
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
}

require("neogit").setup {
  disable_hint = true,
}

require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "-" },
    topdelete = { text = "^" },
    changedelete = { text = "!" },
    untracked = { text = "?" },
  },
  signs_staged = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "-" },
    topdelete = { text = "^" },
    changedelete = { text = "!" },
    untracked = { text = "?" },
  },
  on_attach = function(bufnr)
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal { "]c", bang = true }
      else
        require("gitsigns").nav_hunk "next"
      end
    end, { buffer = bufnr, desc = "Git: next hunk" })
    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal { "[c", bang = true }
      else
        require("gitsigns").nav_hunk "prev"
      end
    end, { buffer = bufnr, desc = "Git: previous hunk" })
    vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { buffer = bufnr, desc = "Git: stage hunk" })
    vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { buffer = bufnr, desc = "Git: reset hunk" })
    vim.keymap.set("v", "<leader>hs", function()
      require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { buffer = bufnr, desc = "Git: stage selected hunk" })
    vim.keymap.set("v", "<leader>hr", function()
      require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { buffer = bufnr, desc = "Git: reset selected hunk" })
    vim.keymap.set("n", "<leader>hS", require("gitsigns").stage_buffer, { buffer = bufnr, desc = "Git: stage buffer" })
    vim.keymap.set("n", "<leader>hR", require("gitsigns").reset_buffer, { buffer = bufnr, desc = "Git: reset buffer" })
    vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
    vim.keymap.set(
      "n",
      "<leader>hi",
      require("gitsigns").preview_hunk_inline,
      { buffer = bufnr, desc = "Git: preview inline hunk" }
    )
    vim.keymap.set("n", "<leader>hb", function()
      require("gitsigns").blame_line { full = true }
    end, { buffer = bufnr, desc = "Git: blame line" })
    vim.keymap.set(
      "n",
      "<leader>hd",
      require("gitsigns").diffthis,
      { buffer = bufnr, desc = "Git: diff against index" }
    )
    vim.keymap.set("n", "<leader>hD", function()
      require("gitsigns").diffthis "~"
    end, { buffer = bufnr, desc = "Git: diff against previous commit" })
    vim.keymap.set("n", "<leader>hQ", function()
      require("gitsigns").setqflist "all"
    end, { buffer = bufnr, desc = "Git: hunks to quickfix (all)" })
    vim.keymap.set(
      "n",
      "<leader>hq",
      require("gitsigns").setqflist,
      { buffer = bufnr, desc = "Git: hunks to quickfix" }
    )
    vim.keymap.set({ "o", "x" }, "ih", require("gitsigns").select_hunk, { buffer = bufnr, desc = "Select inside hunk" })
  end,
}

require("diffview").setup {
  use_icons = false,
}

vim.keymap.set("n", "<leader>gg", function()
  require("neogit").open()
end, { desc = "Open Neogit" })

vim.keymap.set("n", "<leader>gf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file", vim.log.levels.WARN)
    return
  end

  local root = vim.fs.root(file, ".git")
  if not root then
    vim.notify("Current file is not inside a git repository", vim.log.levels.WARN)
    return
  end

  local relative_file = vim.fs.relpath(root, file)
  if not relative_file then
    vim.notify("Current file is not inside the git repository", vim.log.levels.WARN)
    return
  end

  vim.cmd("NeogitLogCurrent " .. vim.fn.fnameescape(relative_file))
end, {
  desc = "Git history for current file",
})
