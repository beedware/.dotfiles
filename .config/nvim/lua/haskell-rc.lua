local mason = require "mason-rc"
local quality = require "quality-rc"
local treesitter = require "treesitter-rc"

local dap_ok = pcall(require, "debugging-rc")

local function refresh_codelens(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end)

  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.cmd "redraw"
    end
  end, 100)
end

local function hoogle_search(query)
  query = query or ""
  query = query ~= "" and query or vim.fn.expand "<cword>"
  query = query ~= "" and query or vim.fn.input "Hoogle: "
  if query == "" then
    return
  end
  if vim.fn.executable "hoogle" ~= 1 then
    vim.notify("Hoogle requires the hoogle executable", vim.log.levels.WARN)
    return
  end

  vim.system({ "hoogle", "--json", query }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(result.stderr and result.stderr ~= "" and result.stderr or "Hoogle search failed", vim.log.levels.ERROR)
        return
      end

      local ok, decoded = pcall(vim.json.decode, result.stdout)
      local entries = ok and decoded or {}
      if vim.tbl_isempty(entries) then
        vim.notify("No Hoogle results for: " .. query, vim.log.levels.WARN)
        return
      end

      local lines = vim.tbl_map(function(item)
        local text = type(item) == "string" and item or item.item or item.self or item.docs or item.url or vim.inspect(item)
        local url = type(item) == "table" and item.url
        text = text:gsub("\n", " ")
        return url and (text .. "\t" .. url) or text
      end, entries)

      require("fzf-lua").fzf_exec(lines, {
        prompt = "Hoogle> ",
        actions = {
          ["default"] = function(selected)
            local url = selected[1] and selected[1]:match "\t(https?://%S+)$"
            if url then
              vim.fn.jobstart({ "xdg-open", url }, { detach = true })
            end
          end,
          ["ctrl-y"] = function(selected)
            local text = selected[1] and (selected[1]:match "^(.-)\t" or selected[1])
            if text then
              vim.fn.setreg("+", text)
            end
          end,
        },
      })
    end)
  end)
end

vim.g.haskell_tools = {
  hls = {
    on_attach = function(_, bufnr, ht)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          map("gd", function()
            vim.cmd.Haskell { "definition" }
          end, "Haskell definition")
        end
      end)

      map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
      map("<leader>cL", function()
        refresh_codelens(bufnr)
      end, "Refresh code lenses")
      map("<leader>hs", hoogle_search, "Hoogle search")
      map("<leader>ha", ht.lsp.buf_eval_all, "Haskell eval all")
      map("<leader>hh", function()
        vim.cmd.Haskell { "hover" }
      end, "Haskell hover actions")
      map("<leader>rp", ht.repl.toggle, "Haskell REPL package")
      map("<leader>rf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, "Haskell REPL file")
      map("<leader>rq", ht.repl.quit, "Haskell REPL quit")

      vim.defer_fn(function()
        refresh_codelens(bufnr)
      end, 250)
    end,
  },
  dap = {
    auto_discover = dap_ok,
  },
}

vim.pack.add {
  {
    src = "https://github.com/MrcJkb/haskell-tools.nvim",
    version = "v11.0.0",
  },
}

mason.add { "haskell-language-server", "fourmolu", "hlint" }
treesitter.add { "haskell" }

quality.formatters { haskell = { "fourmolu" } }
quality.linters { haskell = { "hlint" } }

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("HaskellCodeLensRefresh", { clear = true }),
  pattern = { "*.hs", "*.lhs" },
  callback = function(args)
    refresh_codelens(args.buf)
  end,
})
