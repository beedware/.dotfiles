return {
  "danymat/neogen",
  cmd = "Neogen",
  dependencies = { vim.deepcopy(require "deps.snippets") },
  keys = {
    {
      "<leader>ca",
      function()
        require("neogen").generate()
      end,
      desc = "Generate code annotation",
    },
  },
  opts = function()
    local languages = {}
    for language, config in pairs(require("tools").documentation.configs) do
      languages[language] = type(config) == "function" and config() or config
    end
    return { snippet_engine = "luasnip", languages = languages }
  end,
}
