return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.diagnostic.config {
      underline = false,
    }

    vim.lsp.document_color.enable(false)
    vim.lsp.enable(require("tools").lsp.servers)
  end,
}
