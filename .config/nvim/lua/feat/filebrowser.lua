return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = { { "-", "<cmd>Oil<cr>", desc = "Open file explorer" } },
  opts = {
    delete_to_trash = true,
    view_options = { show_hidden = true },
    columns = { "permissions", "size", "mtime" },
    keymaps = {
      ["<leader>v"] = { "actions.select", opts = { vertical = true } },
      ["<leader>s"] = { "actions.select", opts = { horizontal = true } },
    },
  },
}
