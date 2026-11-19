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

vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("DotenvFt", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
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
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
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
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    if vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf)) <= 1024 * 1024 * 1.5 then
      return
    end
    vim.b[args.buf].bigfile = true
    vim.notify(
      ("Big file detected: %.2f MiB"):format(vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf)) / 1024 / 1024),
      vim.log.levels.WARN,
      { title = "BigFile" }
    )
    vim.wo.foldmethod = "manual"
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.spell = false
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("BigFile", { clear = false }),
  callback = function(args)
    if not vim.b[args.buf].bigfile then
      return
    end
    pcall(vim.treesitter.stop, args.buf)
    pcall(vim.api.nvim_buf_call, args.buf, function()
      vim.cmd.syntax "off"
    end)
  end,
})
