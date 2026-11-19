local o = vim.o
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

local normalized = vim.api.nvim_buf_get_name(0):gsub("\\", "/")
if normalized == "" then
  return
end

local dir = vim.fn.fnamemodify(normalized, ":p:h")
while dir do
  if
    vim.uv.fs_stat(vim.fs.joinpath(dir, "manage.py"))
    or vim.uv.fs_stat(vim.fs.joinpath(dir, "project", "settings.py"))
    or vim.fn.glob(vim.fs.joinpath(dir, "**", "settings.py")) ~= ""
  then
    vim.bo.filetype = "htmldjango"
    return
  end

  local parent = vim.fn.fnamemodify(dir, ":h")
  if parent == dir then
    break
  end
  dir = parent
end

if
  normalized:match "/templates/"
  or normalized:match "/templates/.+%.html$"
  or normalized:match "/app_name/templates/"
then
  vim.bo.filetype = "htmldjango"
elseif vim.fn.filereadable(normalized) == 1 then
  for _, line in ipairs(vim.fn.readfile(normalized, "", 20)) do
    if line:match "{%%" or line:match "{{" or line:match "{#" then
      vim.bo.filetype = "htmldjango"
      return
    end
  end
end
