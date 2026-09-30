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

local colors = require("modus-themes.colors").setup()
local lualine_grey = {
  a = { bg = colors.bg_status_line_active, fg = colors.fg_status_line_active, gui = "bold" },
  b = { bg = colors.bg_status_line_active, fg = colors.fg_status_line_active, gui = "bold" },
  c = { bg = colors.bg_status_line_active, fg = colors.fg_status_line_active },
}

local lualine_theme = {
  normal = lualine_grey,
  insert = lualine_grey,
  visual = lualine_grey,
  replace = lualine_grey,
  command = lualine_grey,
  terminal = lualine_grey,
  inactive = {
    a = { bg = colors.bg_status_line_inactive, fg = colors.fg_status_line_inactive, gui = "bold" },
    b = { bg = colors.bg_status_line_inactive, fg = colors.fg_status_line_inactive, gui = "bold" },
    c = { bg = colors.bg_status_line_inactive, fg = colors.fg_status_line_inactive },
  },
}

require("lualine").setup {
  options = {
    icons_enabled = false,
    theme = lualine_theme,
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = { { "filename", padding = { left = 0, right = 1} } },
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
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}
