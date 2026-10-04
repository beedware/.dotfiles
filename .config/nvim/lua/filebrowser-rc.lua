vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
}

require("oil").setup {
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
  columns = { "permissions", "size", "mtime" },
}

vim.keymap.set("n", "-", function()
    require("oil").open()
end, { desc = "Open file explorer" })

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("OilOpenOnStart", { clear = true }),
  callback = function(data)
    if vim.fn.isdirectory(data.file) ~= 1 then
      return
    end

    vim.schedule(function()
      vim.cmd.cd(data.file)
      vim.cmd("Oil " .. vim.fn.fnameescape(data.file))
    end)
  end,
})

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
