M = {}

function M.deep_copy(object)
  if type(object) ~= "table" then
    return object
  end

  local result = {}
  for key, value in pairs(object) do
    result[key] = M.deep_copy(value)
  end
  return result
end

function M.spread(template, override)
  if not override then
    return function(override)
      M.spread(template, override)
    end
  end

  local mt = getmetatable(template)
  local result = {}
  setmetatable(result, mt)

  for key, value in pairs(template) do
    result[key] = M.deep_copy(value)
  end

  -- No longer wrapped up inside a function
  for key, value in pairs(override) do
    result[key] = value
  end

  return result
end

function M.quick_notification(msg, type)
  astronvim.notify(msg, type or "info", { timeout = 0 })
end

function M.vim_opt_toggle(opt, on, off, name)
  if on == nil then
    on = true
  end
  if off == nil then
    off = false
  end
  if not name then
    name = opt
  end
  local is_off = vim.opt[opt]:get() == off
  vim.opt[opt] = is_off and on or off
  M.quick_notification(name .. " " .. (is_off and "Enabled" or "Disabled"))
end

function M.async_run(cmd, on_finish)
  local lines = { "" }

  local function on_event(_, data, event)
    if (event == "stdout" or event == "stderr") and data then
      vim.list_extend(lines, data)
    end

    if event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = table.concat(cmd, " "),
        lines = lines,
        efm = "%f:%l:%c: %t%n %m",
      })
      if on_finish then
        on_finish()
      end
    end
  end

  vim.fn.jobstart(cmd, {
    on_stdout = on_event,
    on_stderr = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd.cclose()
  elseif not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

function M.better_search(key)
  return function()
    local searched, error = pcall(vim.cmd.normal, {
      args = { (vim.v.count > 0 and vim.v.count or "") .. key },
      bang = true,
    })
    if searched then
      pcall(vim.cmd.normal, "zzzv")
    else
      M.quick_notification(error, "error")
    end
    vim.opt.hlsearch = searched ~= nil
  end
end

return M
