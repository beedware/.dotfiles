local mason = require "mason-rc"
local quality = require "quality-rc"
local treesitter = require "treesitter-rc"

local dap_ok = pcall(require, "debugging-rc")

local function hoogle_item_text(item)
  if type(item) == "string" then
    return item
  end
  return item.item or item.self or item.docs or item.url or vim.inspect(item)
end

local function hoogle_search(query)
  if query == nil or query == "" then
    query = vim.fn.expand "<cword>"
  end
  if query == "" then
    query = vim.fn.input "Hoogle: "
  end
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
        local text = hoogle_item_text(item):gsub("\n", " ")
        return item.url and (text .. "\t" .. item.url) or text
      end, entries)

      require("fzf-lua").fzf_exec(lines, {
        prompt = "Hoogle> ",
        actions = {
          ["default"] = function(selected)
            local url = selected[1] and selected[1]:match("\t(https?://%S+)$")
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

vim.g.haskell_tools = {
  hls = {
    on_attach = function(_, bufnr, ht)
      local opts = { buffer = bufnr }
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.keymap.set("n", "gd", function()
            vim.cmd.Haskell { "definition" }
          end, vim.tbl_extend("force", opts, { desc = "Haskell definition" }))
        end
      end)
      vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run code lens" }))
      vim.keymap.set("n", "<leader>cL", function()
        refresh_codelens(bufnr)
      end, vim.tbl_extend("force", opts, { desc = "Refresh code lenses" }))
      vim.keymap.set("n", "<leader>hs", hoogle_search, vim.tbl_extend("force", opts, { desc = "Hoogle search" }))
      vim.keymap.set("n", "<leader>ha", ht.lsp.buf_eval_all, vim.tbl_extend("force", opts, { desc = "Haskell eval all" }))
      vim.keymap.set("n", "<leader>hh", function()
        vim.cmd.Haskell { "hover" }
      end, vim.tbl_extend("force", opts, { desc = "Haskell hover actions" }))
      vim.keymap.set("n", "<leader>rp", ht.repl.toggle, vim.tbl_extend("force", opts, { desc = "Haskell REPL package" }))
      vim.keymap.set("n", "<leader>rf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, vim.tbl_extend("force", opts, { desc = "Haskell REPL file" }))
      vim.keymap.set("n", "<leader>rq", ht.repl.quit, vim.tbl_extend("force", opts, { desc = "Haskell REPL quit" }))
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

mason.add {
  "haskell-language-server",
  "fourmolu",
  "hlint",
}

treesitter.add { "haskell" }

quality.formatters {
  haskell = { "fourmolu" },
}

quality.linters {
  haskell = { "hlint" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("HaskellCodeLensRefresh", { clear = true }),
  pattern = { "*.hs", "*.lhs" },
  callback = function(args)
    refresh_codelens(args.buf)
  end,
})
