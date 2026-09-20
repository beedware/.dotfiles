vim.pack.add {
  "https://github.com/miikanissi/modus-themes.nvim",
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
    highlights["@org.agenda.scheduled"] = { fg = colors.blue_faint }
    highlights["@org.agenda.scheduled_past"] = { fg = colors.yellow_warmer }
    highlights["@org.agenda.deadline"] = { fg = colors.red_cooler }
    highlights["@org.agenda.deadline.upcoming"] = { fg = colors.magenta_faint }
  end,
}

vim.cmd.colorscheme "modus"
