local opt_local = vim.opt_local
local map = vim.keymap.set
local fn = vim.fn

opt_local.spell = true
opt_local.spelllang = "en_gb"
opt_local.colorcolumn = "80"
opt_local.foldmethod = "expr"
opt_local.foldexpr = "v:lua.typst_foldexpr(v:lnum)"
opt_local.foldlevel = 99
opt_local.foldtext = "v:lua.typst_foldtext()"

function _G.typst_foldexpr(lnum)
  if fn.getline(lnum):match "^=+%s+" then
    return ">1"
  end

  for prev = lnum - 1, 1, -1 do
    if fn.getline(prev):match "^=+%s+" then
      return "1"
    end
  end

  return "0"
end

function _G.typst_foldtext()
  local marker, title = fn.getline(vim.v.foldstart):match "^(=+)%s+(.*%S)"
  if not marker then
    return vim.v.folddashes .. fn.getline(vim.v.foldstart)
  end
  return marker .. " " .. title
end

local function opened_with_flag(flag)
  for _, arg in ipairs(vim.v.argv) do
    if arg == flag then
      return true
    end
  end
  return false
end

if opened_with_flag "-A" then
  opt_local.spell = false
end

require("slipbox").setup()

local function compile_typst(buf)
  if vim.bo[buf].buftype ~= "" then
    return
  end

  local filepath = vim.api.nvim_buf_get_name(buf)

  if filepath == "" then
    return
  end

  if filepath:sub(-4) ~= ".typ" then
    return
  end

  if vim.fn.filereadable(filepath) == 0 then
    return
  end

  local dir = vim.fn.fnamemodify(filepath, ":h")
  local outpath = vim.fs.joinpath(vim.fn.stdpath "cache", "typst-render.pdf")

  local function report_output(_, data)
    if data and #data > 0 then
      print(table.concat(data, "\n"))
    end
  end

  vim.fn.jobstart({ "typst", "compile", filepath, outpath }, {
    cwd = dir,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = report_output,
    on_stderr = report_output,
  })
end

if not vim.g.typst_watch_command_defined then
  vim.g.typst_watch_command_defined = true

  vim.api.nvim_create_user_command("TypstWatch", function(opts)
    local subcommand = opts.args

    if subcommand == "stop" then
      pcall(vim.api.nvim_clear_autocmds, { group = "TypstWatch" })
      vim.notify("Typst watch disabled", vim.log.levels.INFO)
      return
    end

    if subcommand ~= "start" then
      vim.notify("Usage: TypstWatch start|stop", vim.log.levels.ERROR)
      return
    end

    local group = vim.api.nvim_create_augroup("TypstWatch", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = group,
      pattern = "*.typ",
      callback = function(ev)
        compile_typst(ev.buf)
      end,
    })

    compile_typst(vim.api.nvim_get_current_buf())
    vim.notify("Typst watch enabled for this session", vim.log.levels.INFO)
  end, {
    nargs = 1,
    complete = function()
      return { "start", "stop" }
    end,
    desc = "Start or stop Typst auto compile for this session",
  })
end
