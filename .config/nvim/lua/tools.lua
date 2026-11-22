local M = {
  lsp = { servers = {} },
  mason = { packages = {} },
  treesitter = { parsers = {} },
  quality = { formatters_by_ft = { ["_"] = { "trim_whitespace" } }, linters_by_ft = {} },
  debugging = { configurations = {} },
}

function M.lsp.enable(items)
  vim.list_extend(M.lsp.servers, items)
end

function M.mason.add(items)
  vim.list_extend(M.mason.packages, items)
end

function M.treesitter.add(items)
  vim.list_extend(M.treesitter.parsers, items)
end

function M.quality.formatters(items)
  for ft, formatters in pairs(items) do
    M.quality.formatters_by_ft[ft] = formatters
  end
end

function M.quality.linters(items)
  for ft, linters in pairs(items) do
    M.quality.linters_by_ft[ft] = linters
  end
end

function M.debugging.configure(callback)
  M.debugging.configurations[#M.debugging.configurations + 1] = callback
end

function M.format(opts)
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format(opts)
  else
    vim.lsp.buf.format { async = opts.async, timeout_ms = opts.timeout_ms }
  end
end

return M
