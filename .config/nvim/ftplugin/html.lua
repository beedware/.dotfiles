local o = vim.o
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

local function is_django_project(filepath)
  local dir = vim.fn.fnamemodify(filepath, ":p:h")

  while dir do
    local manage_py = vim.fs.joinpath(dir, "manage.py")
    local settings_py = vim.fs.joinpath(dir, "project", "settings.py")
    local settings_glob = vim.fn.glob(vim.fs.joinpath(dir, "**", "settings.py"))

    if vim.uv.fs_stat(manage_py) or vim.uv.fs_stat(settings_py) or settings_glob ~= "" then
      return true
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end

  return false
end

local function html_looks_like_django(filepath)
  if vim.fn.filereadable(filepath) ~= 1 then
    return false
  end

  local lines = vim.fn.readfile(filepath, "", 20)
  for _, line in ipairs(lines) do
    if line:match "{%%" or line:match "{{" or line:match "{#" then
      return true
    end
  end

  return false
end

local path = vim.api.nvim_buf_get_name(0)
local normalized = path:gsub("\\", "/")

if
  normalized ~= ""
  and (
    is_django_project(normalized)
    or normalized:match "/templates/"
    or normalized:match "/templates/.+%.html$"
    or normalized:match "/app_name/templates/"
    or html_looks_like_django(normalized)
  )
then
  vim.bo.filetype = "htmldjango"
end
