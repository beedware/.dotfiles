local quality = require("tools").quality

vim.g.haskell_tools = {
  tools = {
    codeLens = { autoRefresh = false },
  },
  hls = {
    on_attach = function(_, bufnr, ht)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          map("gd", vim.lsp.buf.definition, "Go to definition")
        end
      end)

      map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
      map("<leader>hs", ht.hoogle.hoogle_signature, "Hoogle search for type signature")
      map("<leader>ha", ht.lsp.buf_eval_all, "Haskell eval all")
      map("<leader>hh", function()
        vim.cmd.Haskell { "hover" }
      end, "Haskell hover actions")
      map("<leader>rp", ht.repl.toggle, "Haskell REPL package")
      map("<leader>rf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, "Haskell REPL file")
      map("<leader>rq", ht.repl.quit, "Haskell REPL quit")

    end,
  },
  dap = {
    auto_discover = true,
  },
}

require("tools").mason.add { "haskell-language-server", "fourmolu", "hlint" }
require("tools").treesitter.add { "haskell" }

quality.formatters { haskell = { "fourmolu" } }
quality.linters { haskell = { "hlint" } }

return {
  "MrcJkb/haskell-tools.nvim",
  version = "v11.0.0",
  lazy = false,
  dependencies = { { "mfussenegger/nvim-dap", optional = true } },
  init = function()
    local config = vim.g.haskell_tools or {}
    config.dap = config.dap or {}
    config.dap.auto_discover = require("lazy.core.config").plugins["nvim-dap"] ~= nil
    vim.g.haskell_tools = config
  end,
}
