vim.pack.add {
  "https://github.com/nvim-orgmode/orgmode",
}

local journal_dir = vim.fs.normalize(vim.fn.expand "~/Compendium/Journal")
local path_sep = package.config:sub(1, 1)
local function org_file(name)
  return journal_dir .. path_sep .. name
end

local function unique_files(files)
  local seen = {}
  local result = {}
  for _, file in ipairs(files) do
    local normalized = vim.fs.normalize(file)
    if not seen[normalized] then
      seen[normalized] = true
      table.insert(result, normalized)
    end
  end
  return result
end

local repo_file = org_file "repo.org"
local inbox_file = org_file "inbox.org"
local org_agenda_file_names = {
  "repo.org",
  "wants.org",
  "marks.org",
  "inbox.org",
  "kcl.org",
  "hijri.org",
  "planner.org",
  "done.org",
}
local journal_datetree = {
  tree_type = "custom",
  tree = {
    {
      format = "%Y%m%d",
      pattern = "^(%d%d%d%d)(%d%d)(%d%d)$",
      order = { 1, 2, 3 },
    },
  },
}

local function face_from_hl(hl, opts)
  opts = opts or {}
  local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = true })
  if not ok or not def or not def.fg then
    return opts.fallback or ":weight bold"
  end
  local parts = { string.format(":foreground #%06x", def.fg) }
  if opts.bold then
    table.insert(parts, ":weight bold")
  end
  if opts.italic then
    table.insert(parts, ":slant italic")
  end
  return table.concat(parts, " ")
end

require("orgmode.config.defaults").org_capture_templates = {}

require("orgmode").setup {
  org_agenda_files = unique_files(vim.tbl_map(org_file, org_agenda_file_names)),
  org_default_notes_file = repo_file,
  org_todo_keywords = { "TODO(t)", "PROG(p)", "WAIT(w)", "|", "DONE(d)", "KILL(k)" },
  org_todo_keyword_faces = {
    TODO = face_from_hl("DiagnosticError", { bold = true }),
    PROG = face_from_hl("DiagnosticInfo", { bold = true }),
    WAIT = face_from_hl("DiagnosticWarn", { bold = true }),
    DONE = face_from_hl("DiagnosticOk", { bold = true, fallback = face_from_hl("DiffAdd", { bold = true }) }),
    KILL = face_from_hl("Comment", { italic = true }),
  },
  org_ellipsis = "...",
  org_startup_folded = "overview",
  org_startup_indented = true,
  org_hide_leading_stars = true,
  org_adapt_indentation = false,
  org_log_done = "time",
  org_log_into_drawer = "LOGBOOK",
  org_edit_src_content_indentation = 0,
  ---@diagnostic disable-next-line: assign-type-mismatch
  win_split_mode = "tabnew",
  mappings = {
    capture = {
      org_capture_refile = "<C-w>",
      org_capture_kill = "<C-k>",
    },
  },
  org_capture_templates = {
    i = {
      description = "Inbox",
      template = "* %?",
      target = inbox_file,
    },
    n = {
      description = "Note",
      template = "** %<%H%M%S> - %?",
      target = repo_file,
      ---@diagnostic disable-next-line: missing-fields
      datetree = journal_datetree,
    },
    m = {
      description = "Mark",
      template = "* %^{Title} %^{Tags}\n:PROPERTIES:\n:URL: %^{URL}\n:END:\n\n%^{Description}%?",
      target = org_file "marks.org",
    },
    t = {
      description = "Task",
      template = "* TODO %^{Title} %^{Tags}\n%?",
      target = org_file "planner.org",
    },
    e = {
      description = "Event",
      template = "* %^{Title} %^{Tags}\n%?",
      target = org_file "planner.org",
    },
  },
}

vim.lsp.enable "org"
