vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFolds", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype == "" and not vim.b[args.buf].bigfile then
      vim.wo.foldmethod = "expr"
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("OpenBinaryExternally", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" or path:match "^%w+://" then
      return
    end
    if
      not ({
        png = true,
        jpg = true,
        jpeg = true,
        gif = true,
        webp = true,
        svg = true,
        bmp = true,
        ico = true,
        pdf = true,
        mp4 = true,
        mkv = true,
        mov = true,
        avi = true,
        webm = true,
        mp3 = true,
        wav = true,
        flac = true,
        ogg = true,
      })[vim.fn.fnamemodify(path, ":e"):lower()]
    then
      return
    end
    local _, err = vim.ui.open(path)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    vim.schedule(function()
      if vim.api.nvim_get_current_buf() ~= args.buf then
        return
      end
      pcall(vim.cmd, "silent! b#")
      if vim.api.nvim_get_current_buf() == args.buf then
        pcall(vim.cmd, "silent! enew")
      end
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("AutoResizeSplits", { clear = true }),
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("BigFile", { clear = true }),
  callback = function(args)
    local size_mib = vim.fn.getfsize(args.file) / 1024 / 1024
    if size_mib <= 1.5 then
      return
    end
    vim.b[args.buf].bigfile = true
    vim.notify(("Big file detected: %.2f MiB"):format(size_mib), vim.log.levels.WARN, { title = "BigFile" })
    vim.wo.foldmethod = "manual"
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.spell = false
    vim.opt_local.list = false
  end,
})
