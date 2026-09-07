vim.pack.add {
  "https://github.com/nvim-orgmode/orgmode",
}

local journal_dir = vim.fs.normalize(vim.fn.expand "~/Compendium/Journal")
local repo_file = journal_dir .. package.config:sub(1, 1) .. "repo.org"
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
  org_agenda_files = {
    repo_file,
    journal_dir .. package.config:sub(1, 1) .. "wishlist.org",
  },
  org_default_notes_file = repo_file,
  org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)" },
  org_todo_keyword_faces = {
    TODO = face_from_hl("DiagnosticError", { bold = true }),
    NEXT = face_from_hl("DiagnosticInfo", { bold = true }),
    WAITING = face_from_hl("DiagnosticWarn", { bold = true }),
    DONE = face_from_hl("DiagnosticOk", { bold = true, fallback = face_from_hl("DiffAdd", { bold = true }) }),
    CANCELLED = face_from_hl("Comment", { italic = true }),
  },
  org_ellipsis = "...",
  org_startup_folded = "content",
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
    n = {
      description = "Note",
      template = "** %<%H%M%S> - %?",
      target = repo_file,
      ---@diagnostic disable-next-line: missing-fields
      datetree = journal_datetree,
    },
  },
}

vim.lsp.enable "org"
