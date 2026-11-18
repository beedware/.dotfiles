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
      highlights.Whitespace = { fg = colors.bg_status_line_active }
      highlights.NeogitActiveItem = { bg = colors.bg_dim, fg = colors.fg_main }
      highlights.TabLineSel = { bg = colors.bg_alt, fg = colors.fg_main }
      highlights.QuickFixLineNr = { fg = colors.fg_main, bg = colors.none }
    end,
  },
  config = function(_, opts)
    require("modus-themes").setup(opts)
    vim.cmd.colorscheme "modus"
  end,
}
