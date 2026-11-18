local function setup()
  vim.lsp.config("*", {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            preselectSupport = true,
            snippetSupport = true,
            insertReplaceSupport = true,
            labelDetailsSupport = true,
            deprecatedSupport = true,
            documentationFormat = { "markdown", "plaintext" },
            insertTextModeSupport = { valueSet = { 1 } },
            tagSupport = { valueSet = { 1 } },
            commitCharactersSupport = true,
            resolveSupport = {
              properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
                "command",
                "data",
              },
            },
          },
          completionList = {
            itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
          },
          contextSupport = true,
          insertTextMode = 1,
        },
      },
    },
  })

  vim.diagnostic.config {
    underline = false,
  }

  vim.lsp.document_color.enable(false)
  vim.lsp.enable(require("tools").lsp.servers)
end

return { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" }, config = setup }
