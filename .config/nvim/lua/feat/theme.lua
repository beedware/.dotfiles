return {
  "miikanissi/modus-themes.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
    on_highlights = function(highlights, colors)
      highlights.LspReferenceTarget = {}
      highlights.Whitespace = { fg = colors.bg_status_line_active }
      highlights.NeogitActiveItem = { bg = colors.bg_dim, fg = colors.fg_main }
      highlights.TabLineSel = { bg = colors.bg_alt, fg = colors.fg_main }
      highlights.QuickFixLineNr = { fg = colors.fg_main, bg = colors.none }
      highlights.DiffviewFilePanelInsertions = { fg = colors.green, bg = colors.none }
      highlights.DiffviewFilePanelDeletions = { fg = colors.red, bg = colors.none }
      for _, status in ipairs { "Added", "Untracked" } do
        highlights["DiffviewStatus" .. status] = { fg = colors.green, bg = colors.none }
      end
      for _, status in ipairs { "Modified", "Renamed", "Copied", "TypeChange", "Unmerged" } do
        highlights["DiffviewStatus" .. status] = { fg = colors.yellow, bg = colors.none }
      end
      for _, status in ipairs { "Unknown", "Deleted", "Broken" } do
        highlights["DiffviewStatus" .. status] = { fg = colors.red, bg = colors.none }
      end
    end,
  },
  config = function(_, opts)
    require("modus-themes").setup(opts)
    vim.cmd.colorscheme "modus"
  end,
}
