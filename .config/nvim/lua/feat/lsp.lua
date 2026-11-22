return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  -- Blink registers its completion capabilities before any server starts.
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.diagnostic.config {
      underline = false,
    }

    vim.lsp.document_color.enable(false)
    vim.lsp.enable(require("tools").lsp.servers)
  end,
}
