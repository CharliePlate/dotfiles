local M = {}

M.filter = function(tbl, condition)
  local filtered = {}
  for i, v in ipairs(tbl) do
    if condition(v, i) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

M.isTableOfTables = function(t)
  -- Check if the table is empty
  if next(t) == nil then
    return false
  end

  -- Check if all keys are integers (array-style indexing)
  for key, value in pairs(t) do
    if type(key) ~= "number" then
      return false -- Not an array-style table
    end
    if type(value) ~= "table" then
      return false -- Not containing only tables
    end
  end
  return true
end

---@param on_attach fun(client: vim.lsp.Client?, buffer: number): nil
M.lspOnAttach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.opts = function(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param arr1 table
---@param arr2 table
M.mergeArrays = function(arr1, arr2)
  local merged = {}
  for _, v in ipairs(arr1) do
    table.insert(merged, v)
  end
  for _, v in ipairs(arr2) do
    table.insert(merged, v)
  end
  return merged
end

M.is_loaded = function(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

local function get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

local function lsp_root(buf)
  local bufpath = M.bufpath(vim.api.nvim_buf_get_name(assert(buf)))
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  for _, client in pairs(get_clients({ bufnr = buf })) do
    -- only check workspace folders, since we're not interested in clients
    -- running in single file mode
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
  end
  return vim.tbl_filter(function(path)
    path = require("lazy.core.util").norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

function M.bufpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path
  return require("lazy.core.util").norm(path)
end

function M.lspRoot()
  print(vim.api.nvim_get_current_buf())
  return lsp_root(vim.api.nvim_get_current_buf())[1]
end

return M
