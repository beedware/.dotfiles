local config = vim.tbl_extend("force", {
  executable = "NuSMV",
  args = {},
  reveal_output = "always",
}, vim.g.nusmv or {})

vim.filetype.add {
  extension = {
    smv = "nusmv",
  },
}

local group = vim.api.nvim_create_augroup("NuSMV", { clear = true })

local active_run
local output_buf

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "NuSMV" })
end

local function show_output()
  if not output_buf or not vim.api.nvim_buf_is_valid(output_buf) then
    return notify "No NuSMV output yet"
  end
  if vim.fn.bufwinid(output_buf) == -1 then
    vim.cmd "botright 12split"
    vim.api.nvim_win_set_buf(0, output_buf)
  end
end

local function executable()
  if vim.fn.executable(config.executable) ~= 1 then
    notify("NuSMV executable not found: " .. config.executable .. ". Set vim.g.nusmv.executable.", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function model_command()
  local path = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype ~= "nusmv" or vim.bo.buftype ~= "" or path == "" then
    notify("Open and save a NuSMV model first", vim.log.levels.WARN)
    return
  end
  local ok, err = pcall(vim.cmd, "update")
  if not ok then
    notify("Cannot save model: " .. err, vim.log.levels.ERROR)
    return
  end
  if not executable() then
    return
  end
  local cmd = { config.executable }
  vim.list_extend(cmd, config.args)
  cmd[#cmd + 1] = path
  return cmd, vim.fs.dirname(path)
end

local function terminal(cmd, cwd)
  vim.cmd "botright 12new"
  vim.fn.jobstart(cmd, { term = true, cwd = cwd })
  vim.cmd "startinsert"
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    if active_run then
      active_run.process:kill(15)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "nusmv",
  callback = function(event)
    vim.api.nvim_buf_create_user_command(event.buf, "NuSMVRun", function()
      if active_run then
        return notify("A NuSMV run is already in progress; use :NuSMVStop", vim.log.levels.WARN)
      end
      local cmd, cwd = model_command()
      if not cmd then
        return
      end
      output_buf = vim.api.nvim_create_buf(false, true)
      local buf = output_buf
      vim.bo[buf].filetype = "nusmvoutput"
      vim.bo[buf].bufhidden = "hide"
      local header =
        { "Command: " .. table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " "), "Directory: " .. cwd, "" }
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, header)
      if config.reveal_output == "always" then
        show_output()
      end
      local run = { cancelled = false }
      active_run = run
      local started = vim.uv.hrtime()
      local ok, process = pcall(vim.system, cmd, { cwd = cwd, text = true }, function(result)
        vim.schedule(function()
          active_run = nil
          local output = (result.stdout or "") .. "\n" .. (result.stderr or "")
          local passed, failed = 0, 0
          for line in output:gmatch "[^\n]+" do
            local verdict = line:lower():match "^%s*%-%-%s*specification%f[%W].-%f[%w]is%s+(%a+)%f[%W]"
            if verdict == "true" then
              passed = passed + 1
            elseif verdict == "false" then
              failed = failed + 1
            end
          end
          local level = run.cancelled and vim.log.levels.WARN
            or result.code ~= 0 and vim.log.levels.ERROR
            or failed > 0 and vim.log.levels.WARN
            or vim.log.levels.INFO
          local summary = ("%s in %.1fs (exit %d). Specs: %d true, %d false."):format(
            run.cancelled and "Cancelled" or result.code ~= 0 and "Error" or failed > 0 and "Failed" or "Completed",
            (vim.uv.hrtime() - started) / 1e9,
            result.code,
            passed,
            failed
          )
          if vim.api.nvim_buf_is_valid(buf) then
            vim.list_extend(header, vim.split(output, "\n", { plain = true }))
            header[#header + 1] = summary
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, header)
            vim.bo[buf].modifiable = false
            if config.reveal_output == "onFailure" and level ~= vim.log.levels.INFO then
              show_output()
            end
          end
          notify(summary, level)
        end)
      end)
      if not ok then
        active_run = nil
        return notify("Cannot start NuSMV: " .. tostring(process), vim.log.levels.ERROR)
      end
      run.process = process
    end, {
      desc = "Save and run current NuSMV model; capture output and summarize specs",
    })
    vim.api.nvim_buf_create_user_command(event.buf, "NuSMVStop", function()
      if active_run then
        active_run.cancelled = true
        active_run.process:kill(15)
      end
    end, { desc = "Cancel the current NuSMV run" })
    vim.api.nvim_buf_create_user_command(event.buf, "NuSMVRunTerminal", function()
      local cmd, cwd = model_command()
      if cmd then
        terminal(cmd, cwd)
      end
    end, { desc = "Save and run current NuSMV model in a terminal" })
    vim.api.nvim_buf_create_user_command(event.buf, "NuSMVShell", function()
      if executable() then
        local path = vim.api.nvim_buf_get_name(0)
        terminal({ config.executable, "-int" }, path ~= "" and vim.fs.dirname(path) or vim.fn.getcwd())
      end
    end, { desc = "Open an interactive NuSMV shell" })
    vim.api.nvim_buf_create_user_command(
      event.buf,
      "NuSMVOutput",
      show_output,
      { desc = "Show the last NuSMV run output" }
    )
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.commentstring = "-- %s"
    vim.bo.comments = ":--"
    vim.opt_local.iskeyword = "@,48-57,_,36,35,45"
    vim.wo.foldmethod = "manual"
    vim.keymap.set("n", "<localleader>r", "<Cmd>NuSMVRun<CR>", { buffer = true, desc = "Run NuSMV model" })
    vim.keymap.set("n", "<localleader>i", "<Cmd>NuSMVShell<CR>", { buffer = true, desc = "NuSMV interactive shell" })
  end,
})

return {}
