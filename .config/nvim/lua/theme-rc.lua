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
    highlights.Whitespace = { fg = colors.bg_status_line_active }
    highlights.VisualWhitespace = { fg = colors.indigo, bg = colors.visual }
  end,
}

vim.cmd.colorscheme "modus"

local visual_whitespace = vim.api.nvim_create_namespace "VisualWhitespace"
local marked_buf

local function update_visual_whitespace()
  if marked_buf and vim.api.nvim_buf_is_valid(marked_buf) then
    vim.api.nvim_buf_clear_namespace(marked_buf, visual_whitespace, 0, -1)
  end
  marked_buf = nil

  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return
  end

  local ok, region = pcall(vim.fn.getregionpos, vim.fn.getpos "v", vim.fn.getpos ".", { type = mode })
  if not ok then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  marked_buf = buf
  local count = 0
  for _, range in ipairs(region) do
    local row = range[1][2] - 1
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
    local col = line:find("[ \t]", math.max(range[1][3], 1))
    while col and col <= range[2][3] do
      vim.api.nvim_buf_set_extmark(buf, visual_whitespace, row, col - 1, {
        virt_text = { { line:sub(col, col) == "\t" and "→" or "·", "VisualWhitespace" } },
        virt_text_pos = "overlay",
      })
      count = count + 1
      if count >= 1000 then
        return
      end
      col = line:find("[ \t]", col + 1)
    end
  end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("VisualWhitespace", { clear = true }),
  callback = update_visual_whitespace,
})
