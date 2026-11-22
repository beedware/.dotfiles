local o = vim.o
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

local normalized = vim.api.nvim_buf_get_name(0):gsub("\\", "/")
if normalized == "" then
  return
end

-- Neovim already detects Django tags. Also recognize project and template paths.
if normalized:match "/templates/" or vim.fs.root(0, { "manage.py", "settings.py" }) then
  vim.bo.filetype = "htmldjango"
  return
end

for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 20, false)) do
  if line:match "{%%" or line:match "{{" or line:match "{#" then
    vim.bo.filetype = "htmldjango"
    return
  end
end
