vim.pack.add {
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
}

require("modus-themes").setup {
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  },
  on_highlights = function(highlights, colors)
    highlights.NeogitActiveItem = { bg = colors.bg_dim, fg = colors.fg_main }
    highlights.TabLineSel = { bg = colors.bg_alt, fg = colors.fg_main }
    highlights.QuickFixLineNr = { fg = colors.fg_main, bg = colors.none }
  end,
}

vim.cmd.colorscheme "modus"

vim.opt.showmode = false

local function truncate_branch(branch)
  if #branch <= 8 then
    return branch
  end

  return branch:sub(1, 8) .. "~"
end

local function branch_with_dirty(branch)
  branch = truncate_branch(branch)

  local git_status = vim.b.gitsigns_status_dict
  if not git_status then
    return " @" .. branch
  end

  local changed = (git_status.added or 0) + (git_status.changed or 0) + (git_status.removed or 0)
  if changed == 0 then
    return " @" .. branch
  end

  return " *" .. branch
end

require("lualine").setup {
  options = {
    icons_enabled = false,
    component_separators = "",
    section_separators = "",
    refresh = {
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
        "DiagnosticChanged",
      },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {
      { "branch", fmt = branch_with_dirty },
      {
        "lsp_status",
        symbols = {
          spinner = { "-", "\\", "|", "/" },
          done = "",
          separator = " ",
        },
      },
      { "diagnostics", padding = { left = 0, right = 1} },
    },
    lualine_y = { "location" },
    lualine_z = {
      {
        "progress",
        fmt = function(progress)
          local value, suffix = progress:match("^%s*(%d+)(.*)$")
          if value then
            return string.format("%02d", value) .. suffix
          end

          return progress
        end,
      },
    },
  },
}
