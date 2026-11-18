vim.pack.add {
  "https://github.com/danymat/neogen",
}

local M = {}
local languages = {}

local function configure()
  require("neogen").setup {
    snippet_engine = "luasnip",
    languages = languages,
  }
end

function M.languages(items)
  for language, config in pairs(items) do
    languages[language] = config
  end
  configure()
end

configure()

vim.keymap.set("n", "<leader>ca", function()
  require("neogen").generate()
end, { desc = "Generate code annotation" })

return M
