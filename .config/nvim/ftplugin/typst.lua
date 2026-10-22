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

local function in_slipbox()
  local buf_path = fn.resolve(vim.api.nvim_buf_get_name(0))
  return buf_path:find(fn.resolve(fn.expand "~/Compendium/Slipbox"), 1, true) ~= nil
end

local function notify_no_matches()
  vim.notify("No matching Typst files found", vim.log.levels.INFO)
end

local function open_qflist()
  if fn.getqflist({ size = 0 }).size == 0 then
    notify_no_matches()
    return false
  end
  vim.cmd "copen"
  return true
end

local function typst_title_text(line)
  return line:match [[#let%s+title%s*=%s*"([^"]*)"]] or line
end

local function typst_file_tags(filename)
  if not filename or filename == "" then
    return ""
  end

  local ok, lines = pcall(fn.readfile, filename, "", 40)
  if not ok then
    return ""
  end

  for _, line in ipairs(lines) do
    local tag_text = line:match "^%s*#id:([^%s]+)"
    if tag_text then
      return ":" .. tag_text
    end
  end

  return ""
end

local function typst_title_entry_text(filename, line)
  local title = typst_title_text(line)
  local tags = typst_file_tags(filename)
  if tags == "" then
    return title
  end
  return title .. " " .. tags
end

local function simplify_qflist_title_text()
  local items = fn.getqflist()
  for _, item in ipairs(items) do
    item.text = typst_title_entry_text(fn.bufname(item.bufnr), item.text)
  end
  fn.setqflist({}, "r", { title = "Typst titles", items = items })
end

local function search_with_vimgrep(pattern)
  local escaped = fn.escape(pattern, [[/\]])
  local cwd = fn.getcwd()
  vim.cmd("silent vimgrep /" .. escaped .. "/gj " .. cwd .. "/**/*.typ")
  simplify_qflist_title_text()
  open_qflist()
end

local function search_with_rg(pattern)
  local rg_cmd = {
    "rg",
    "--vimgrep",
    "--glob",
    "*.typ",
    "--fixed-strings",
    "--",
    pattern,
    fn.getcwd(),
  }

  local results = fn.systemlist(rg_cmd)
  if vim.v.shell_error > 1 then
    vim.notify("rg failed", vim.log.levels.ERROR)
    return
  end
  if #results == 0 then
    notify_no_matches()
    return
  end

  local items = {}
  for _, result in ipairs(results) do
    local filename, lnum, col, text = result:match "^(.-):(%d+):(%d+):(.*)$"
    if filename then
      table.insert(items, {
        filename = filename,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = typst_title_entry_text(filename, text),
      })
    end
  end

  fn.setqflist({}, "r", { title = "Typst titles", items = items })
  vim.cmd "copen"
end

local function search_slipbox_titles_fallback()
  local pattern = '#let title = "'
  if fn.executable "rg" == 1 then
    search_with_rg(pattern)
    return
  end
  search_with_vimgrep(pattern)
end

local function slipbox_notes()
  local dir = fn.resolve(fn.expand "~/Compendium/Slipbox")
  local notes = {}

  for _, path in ipairs(fn.globpath(dir, "*.typ", false, true)) do
    local id = fn.fnamemodify(path, ":t:r")
    if id:match "^%d%d%d%d%d%d%d%d%d%d%d%d%d%d$" then
      local ok, lines = pcall(fn.readfile, path, "", 40)
      if ok then
        for _, line in ipairs(lines) do
          local title = line:match [[^#let%s+title%s*=%s*"([^"]*)"]]
          if title then
            table.insert(notes, { id = id, title = title, path = path })
            break
          end
        end
      end
    end
  end

  table.sort(notes, function(a, b)
    return a.title:lower() < b.title:lower() or a.title:lower() == b.title:lower() and a.id < b.id
  end)
  return notes
end

local function search_slipbox_titles()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    search_slipbox_titles_fallback()
    return
  end

  local notes = slipbox_notes()
  if #notes == 0 then
    notify_no_matches()
    return
  end

  local entries = {}
  local by_entry = {}
  for _, note in ipairs(notes) do
    local entry = note.title .. " [" .. note.id .. "]"
    table.insert(entries, entry)
    by_entry[entry] = note.path
  end

  fzf.fzf_exec(entries, {
    prompt = "Slipbox title> ",
    actions = {
      ["default"] = function(selected)
        local path = by_entry[selected[1]]
        if path then
          vim.cmd.edit(fn.fnameescape(path))
        end
      end,
    },
  })
end

local function slipbox_backlinks(id)
  id = id ~= "" and id or fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
  if not id:match "^%d%d%d%d%d%d%d%d%d%d%d%d%d%d$" then
    vim.notify("Expected a timestamp-style note ID", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, note in ipairs(slipbox_notes()) do
    if note.id ~= id then
      local lines = fn.readfile(note.path)
      local in_links = false
      for lnum, line in ipairs(lines) do
        if line:match "^= Links%s*$" then
          in_links = true
        elseif in_links and line:match "^=" then
          in_links = false
        elseif in_links and line:match "^#bibliography" then
          break
        elseif in_links and line:match("^%s*%-%s*" .. id .. "%s*$") then
          table.insert(items, {
            filename = note.path,
            lnum = lnum,
            col = 1,
            text = note.title,
          })
          break
        end
      end
    end
  end

  if #items == 0 then
    fn.setqflist({}, "r", { title = "Backlinks to " .. id, items = {} })
    vim.notify("No backlinks found for " .. id, vim.log.levels.INFO)
    return
  end

  fn.setqflist({}, "r", { title = "Backlinks to " .. id, items = items })
  vim.cmd "copen"
end

local function insert_slipbox_id()
  local notes = slipbox_notes()
  if #notes == 0 then
    notify_no_matches()
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
  col = math.min(col + 1, #line)

  local function insert(note)
    if not note or not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    vim.api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { note.id })
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
      vim.api.nvim_win_set_cursor(win, { row, col + #note.id })
    end
  end

  local ok, fzf = pcall(require, "fzf-lua")
  if ok then
    local entries = {}
    local by_entry = {}
    for _, note in ipairs(notes) do
      local entry = note.title .. " [" .. note.id .. "]"
      table.insert(entries, entry)
      by_entry[entry] = note
    end
    fzf.fzf_exec(entries, {
      prompt = "Slipbox title> ",
      actions = {
        ["default"] = function(selected)
          insert(by_entry[selected[1]])
        end,
      },
    })
    return
  end

  vim.ui.input({ prompt = "Slipbox title: " }, function(query)
    if not query or query == "" then
      return
    end
    local matches = {}
    for _, note in ipairs(notes) do
      if note.title:lower():find(query:lower(), 1, true) then
        table.insert(matches, note)
      end
    end
    if #matches == 0 then
      notify_no_matches()
    elseif #matches == 1 then
      insert(matches[1])
    else
      vim.ui.select(matches, {
        prompt = "Slipbox title: ",
        format_item = function(note)
          return note.title .. " [" .. note.id .. "]"
        end,
      }, insert)
    end
  end)
end

vim.api.nvim_buf_create_user_command(0, "SlipboxBacklinks", function(opts)
  slipbox_backlinks(opts.args)
end, {
  nargs = "?",
  complete = function()
    local ids = {}
    for _, note in ipairs(slipbox_notes()) do
      table.insert(ids, note.id)
    end
    return ids
  end,
  desc = "Find notes linking to the current note or a given ID",
})

local function set_slipbox(enabled)
  pcall(vim.keymap.del, "n", "<leader>fn", { buffer = true })
  for _, key in ipairs { "<leader>zn", "<leader>zb", "<leader>zi" } do
    pcall(vim.keymap.del, "n", key, { buffer = true })
  end

  if not enabled then
    return
  end

  map("n", "<leader>zn", search_slipbox_titles, {
    buffer = true,
    desc = "Find slipbox notes by title",
  })
  map("n", "<leader>zb", function()
    slipbox_backlinks ""
  end, { buffer = true, desc = "Find backlinks to this slipbox note" })
  map("n", "<leader>zi", insert_slipbox_id, {
    buffer = true,
    desc = "Insert a slipbox note ID by title",
  })
end

set_slipbox(in_slipbox())

vim.api.nvim_buf_create_user_command(0, "SlipboxTesting", function(opts)
  if opts.args == "on" then
    set_slipbox(true)
    vim.notify("Slipbox mappings enabled", vim.log.levels.INFO)
    return
  end

  if opts.args == "off" then
    set_slipbox(in_slipbox())
    vim.notify("Slipbox mappings restored to default", vim.log.levels.INFO)
    return
  end

  vim.notify("Usage: SlipboxTesting on|off", vim.log.levels.ERROR)
end, {
  nargs = 1,
  complete = function()
    return { "on", "off" }
  end,
  desc = "Enable Slipbox mappings or restore Typst default",
})

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

  vim.fn.jobstart({ "typst", "compile", filepath, outpath }, {
    cwd = dir,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        print(table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        print(table.concat(data, "\n"))
      end
    end,
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
