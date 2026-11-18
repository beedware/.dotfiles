vim.pack.add {
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/neovim/nvim-lspconfig",
}

local M = {}

require("lazydev").setup {
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
}

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          preselectSupport = true,
          commitCharactersSupport = true,
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  },
})

vim.diagnostic.config {
  underline = false,
}

vim.lsp.document_color.enable(false)

function M.enable(servers)
  vim.lsp.enable(servers)
end

function M.pack_add(packages)
  vim.pack.add(packages)
end

return M
