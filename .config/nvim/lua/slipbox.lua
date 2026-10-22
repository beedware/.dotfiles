local M = {}
local fn = vim.fn
local api = vim.api
local root = fn.resolve(fn.expand "~/Compendium/Slipbox")

local function valid_id(id)
  return #id == 14 and id:match "^%d+$" ~= nil
end

local function tags_from_line(line, id)
  local tags = line:match "^%s*:#id:(.-):%s*$" or line:match("^%s*:" .. id .. ":(.-):%s*$")
  return tags and tags ~= "" and ":" .. tags .. ":" or ""
end

local function notes()
  local found = {}
  for _, path in ipairs(fn.globpath(root, "*.typ", false, true)) do
    local id = fn.fnamemodify(path, ":t:r")
    if valid_id(id) then
      local ok, lines = pcall(fn.readfile, path, "", 40)
      if ok then
        local title, tags, lnum
        for i, line in ipairs(lines) do
          title = title or line:match [[^#let%s+title%s*=%s*"([^"]*)"]]
          if not tags or tags == "" then
            tags = tags_from_line(line, id)
          end
          if line:match "^=%s+#title%s*$" then
            lnum = i
          end
        end
        if title then
          table.insert(found, { id = id, title = title, tags = tags or "", path = path, lnum = lnum or 1 })
        end
      end
    end
  end
  table.sort(found, function(a, b)
    return a.title:lower() < b.title:lower() or a.title:lower() == b.title:lower() and a.id < b.id
  end)
  return found
end

local function label(note)
  return note.title .. (note.tags ~= "" and "  " .. note.tags or "")
end

local function entries_for(found)
  local entries, by_entry, by_note = {}, {}, {}
  for _, note in ipairs(found) do
    local entry = label(note)
    local suffix = 2
    while by_entry[entry] do
      entry = note.title .. " (" .. suffix .. ")" .. (note.tags ~= "" and "  " .. note.tags or "")
      suffix = suffix + 1
    end
    table.insert(entries, entry)
    by_entry[entry] = note
    by_note[note] = entry
  end
  return entries, by_entry, by_note
end

local function notify_empty(message)
  vim.notify(message or "No matching Typst notes found", vim.log.levels.INFO)
end

local function quickfix(title, items)
  fn.setqflist({}, "r", { title = title, items = items })
  if #items == 0 then
    notify_empty()
  else
    vim.cmd "copen"
  end
end

local function item_for(note, lnum)
  return { filename = note.path, lnum = lnum or note.lnum, col = 1, text = label(note) }
end

local function find_titles()
  local found = notes()
  if #found == 0 then
    notify_empty()
    return
  end

  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    local items = {}
    for _, note in ipairs(found) do
      table.insert(items, item_for(note))
    end
    quickfix("Slipbox notes", items)
    return
  end

  local entries, by_entry = entries_for(found)
  fzf.fzf_exec(entries, {
    prompt = "Title> ",
    fzf_opts = { ["--multi"] = true },
    actions = {
      ["default"] = function(selected)
        local note = by_entry[selected[1]]
        if note then
          vim.cmd.edit(fn.fnameescape(note.path))
        end
      end,
      ["ctrl-q"] = {
        prefix = "select-all",
        fn = function(selected)
          local items = {}
          for _, entry in ipairs(selected) do
            local note = by_entry[entry]
            if note then
              table.insert(items, item_for(note))
            end
          end
          quickfix("Slipbox notes", items)
        end,
      },
    },
  })
end

local function backlinks(id)
  id = id ~= "" and id or fn.fnamemodify(api.nvim_buf_get_name(0), ":t:r")
  if not valid_id(id) then
    vim.notify("Expected a timestamp-style note ID", vim.log.levels.WARN)
    return
  end

  local items = {}
  for _, note in ipairs(notes()) do
    if note.id ~= id then
      local in_links = false
      for lnum, line in ipairs(fn.readfile(note.path)) do
        if line:match "^= Links%s*$" then
          in_links = true
        elseif in_links and (line:match "^=" or line:match "^#bibliography") then
          in_links = false
        elseif in_links and line:match("^%s*%-%s*" .. id .. "%s*$") then
          table.insert(items, item_for(note, lnum))
          break
        end
      end
    end
  end
  quickfix("Backlinks to " .. id, items)
end

local function insert_id()
  local found = notes()
  if #found == 0 then
    notify_empty()
    return
  end

  local buf, win = api.nvim_get_current_buf(), api.nvim_get_current_win()
  local row, col = unpack(api.nvim_win_get_cursor(win))
  col = math.min(col + 1, #api.nvim_buf_get_lines(buf, row - 1, row, false)[1])

  local function insert(note)
    if not note or not api.nvim_buf_is_valid(buf) then
      return
    end
    api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { note.id })
    if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == buf then
      api.nvim_win_set_cursor(win, { row, col + #note.id })
    end
  end

  local entries, by_entry, by_note = entries_for(found)
  local ok, fzf = pcall(require, "fzf-lua")
  if ok then
    fzf.fzf_exec(entries, {
      prompt = "Title> ",
      actions = {
        ["default"] = function(selected)
          insert(by_entry[selected[1]])
        end,
      },
    })
    return
  end

  vim.ui.input({ prompt = "Title: " }, function(query)
    if not query or query == "" then
      return
    end
    local matches = {}
    for _, note in ipairs(found) do
      if note.title:lower():find(query:lower(), 1, true) then
        table.insert(matches, note)
      end
    end
    if #matches == 0 then
      notify_empty()
    elseif #matches == 1 then
      insert(matches[1])
    else
      vim.ui.select(matches, {
        prompt = "Title: ",
        format_item = function(note)
          return by_note[note]
        end,
      }, insert)
    end
  end)
end

function M.setup()
  local buf = api.nvim_get_current_buf()
  local function set_mappings(enabled)
    for _, key in ipairs { "<leader>zn", "<leader>zb", "<leader>zi" } do
      pcall(vim.keymap.del, "n", key, { buffer = buf })
    end
    if enabled then
      vim.keymap.set("n", "<leader>zn", find_titles, { buffer = buf, desc = "Find slipbox notes by title" })
      vim.keymap.set("n", "<leader>zb", function()
        backlinks ""
      end, {
        buffer = buf,
        desc = "Find backlinks to this slipbox note",
      })
      vim.keymap.set("n", "<leader>zi", insert_id, { buffer = buf, desc = "Insert a slipbox note ID by title" })
    end
  end

  local function in_slipbox()
    local path = fn.resolve(api.nvim_buf_get_name(buf))
    return path:sub(1, #root + 1) == root .. "/"
  end

  set_mappings(in_slipbox())
  api.nvim_buf_create_user_command(buf, "SlipboxBacklinks", function(opts)
    backlinks(opts.args)
  end, {
    nargs = "?",
    complete = function()
      local ids = {}
      for _, note in ipairs(notes()) do
        table.insert(ids, note.id)
      end
      return ids
    end,
    desc = "Find notes linking to the current note or a given ID",
  })
  api.nvim_buf_create_user_command(buf, "SlipboxTesting", function(opts)
    if opts.args == "on" or opts.args == "off" then
      set_mappings(opts.args == "on" or in_slipbox())
      vim.notify("Slipbox mappings " .. (opts.args == "on" and "enabled" or "restored to default"))
    else
      vim.notify("Usage: SlipboxTesting on|off", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "on", "off" }
    end,
    desc = "Enable Slipbox mappings or restore Typst default",
  })
end

return M
