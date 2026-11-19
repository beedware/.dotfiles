return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = { {
    "-",
    function()
      require("oil").open()
    end,
    desc = "Open file explorer",
  } },
  opts = {
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<leader>v"] = { "actions.select", opts = { vertical = true } },
      ["<leader>s"] = { "actions.select", opts = { horizontal = true } },
    },
    columns = { "permissions", "size", "mtime" },
  },
  init = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
      group = vim.api.nvim_create_augroup("OilOpenDirectories", { clear = true }),
      callback = function(args)
        local directory = vim.api.nvim_buf_get_name(args.buf)
        if directory == "" or vim.fn.isdirectory(directory) ~= 1 then
          return
        end
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(args.buf) or vim.api.nvim_get_current_buf() ~= args.buf then
            return
          end
          if args.event == "VimEnter" then
            vim.cmd.cd(directory)
          end
          require("oil").open(directory)
        end)
      end,
    })
  end,
  config = function(_, opts)
    require("oil").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("OilDetailMappings", { clear = true }),
      pattern = "oil",
      callback = function(args)
        vim.b[args.buf].oil_detail = vim.b[args.buf].oil_detail or false
        vim.keymap.set("n", "gd", function()
          vim.b[args.buf].oil_detail = not vim.b[args.buf].oil_detail
          if vim.b[args.buf].oil_detail then
            require("oil").set_columns { "permissions", "size", "mtime" }
          else
            require("oil").set_columns {}
          end
        end, { buffer = args.buf, desc = "Toggle file detail view" })
      end,
    })
  end,
}
