local signs = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "-" },
  topdelete = { text = "^" },
  changedelete = { text = "!" },
  untracked = { text = "?" },
}

return {
  {
    "NeogitOrg/neogit",
    cmd = { "Neogit", "NeogitResetState", "NeogitLogCurrent", "NeogitCommit" },
    dependencies = {
      {
        "sindrets/diffview.nvim",
        cmd = {
          "DiffviewOpen",
          "DiffviewFileHistory",
          "DiffviewClose",
          "DiffviewFocusFiles",
          "DiffviewToggleFiles",
          "DiffviewRefresh",
          "DiffviewLog",
        },
        opts = {
          use_icons = false,
        },
      },
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
      {
        "<leader>gf",
        function()
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
        end,
        desc = "Git history for current file",
      },
    },
    opts = {
      disable_hint = true,
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = signs,
      signs_staged = vim.deepcopy(signs),
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { buffer = bufnr, desc = "Git: next hunk" })
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { buffer = bufnr, desc = "Git: previous hunk" })
        vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Git: stage hunk" })
        vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Git: reset hunk" })
        vim.keymap.set("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { buffer = bufnr, desc = "Git: stage selected hunk" })
        vim.keymap.set("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { buffer = bufnr, desc = "Git: reset selected hunk" })
        vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Git: stage buffer" })
        vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Git: reset buffer" })
        vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
        vim.keymap.set(
          "n",
          "<leader>hi",
          gitsigns.preview_hunk_inline,
          { buffer = bufnr, desc = "Git: preview inline hunk" }
        )
        vim.keymap.set("n", "<leader>hb", function()
          gitsigns.blame_line { full = true }
        end, { buffer = bufnr, desc = "Git: blame line" })
        vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr, desc = "Git: diff against index" })
        vim.keymap.set("n", "<leader>hD", function()
          gitsigns.diffthis "~"
        end, { buffer = bufnr, desc = "Git: diff against previous commit" })
        vim.keymap.set("n", "<leader>hQ", function()
          gitsigns.setqflist "all"
        end, { buffer = bufnr, desc = "Git: hunks to quickfix (all)" })
        vim.keymap.set("n", "<leader>hq", gitsigns.setqflist, { buffer = bufnr, desc = "Git: hunks to quickfix" })
        vim.keymap.set({ "o", "x" }, "ih", gitsigns.select_hunk, { buffer = bufnr, desc = "Select inside hunk" })
      end,
    },
  },
}
