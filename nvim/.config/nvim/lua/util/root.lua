local M = {}

M.tracked_by_yadm = function()
  if vim.g.tracked_by_yadm ~= nil then
    return vim.g.tracked_by_yadm
  end

  local current_dir = vim.fn.getcwd()
  local cmd = "yadm ls-tree --full-tree --name-only -r HEAD"
  local home_dir = os.getenv("HOME")
  local home_len = string.len(home_dir or "")

  local handle = io.popen(cmd .. " | grep " .. vim.fn.shellescape(string.sub(current_dir, home_len + 2)))
  if handle == nil then
    print("Error running command: " .. cmd)
    return
  end
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    vim.g.tracked_by_yadm = false
    return false
  else
    vim.g.tracked_by_yadm = true
    return true
  end
end

return M
