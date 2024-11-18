local fn = require("util.fn")

---@class Lang
local M = {}

---@param t table
---@return table<table>
M.makeSpec = function(t)
  local spec = {}
  for _, value in ipairs(t) do
    if fn.isTableOfTables(value) then
      for _, v in ipairs(value) do
        table.insert(spec, v)
      end
    else
      table.insert(spec, value)
    end
  end
  return spec
end

---@param formatter table<string, table<table<string>>> | table<string>
---@param install boolean?
---@return table
M.addFormatter = function(formatter, install)
  return {
    {
      "stevearc/conform.nvim",
      opts = function(_, opts)
        opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, formatter)
      end,
    },
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        if install == nil or install then
          for _, value in pairs(formatter) do
            if fn.isTableOfTables(value) then
              for _, v in ipairs(value) do
                vim.list_extend(
                  opts.ensure_installed,
                  fn.filter(v, function(f)
                    return not vim.tbl_contains(opts.ensure_installed, f)
                  end)
                )
              end
            else
              vim.list_extend(
                opts.ensure_installed,
                fn.filter(value, function(f)
                  return not vim.tbl_contains(opts.ensure_installed, f)
                end)
              )
            end
          end
        end
      end,
    },
  }
end

---@param filetypes string[]
M.addTreesitterFiletypes = function(filetypes)
  return {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, filetypes)
    end,
  }
end

---@param lsp string
---@param hints? boolean
M.addLspServer = function(lsp, hints)
  return {
    {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        local ok, config = pcall(require, "config.lsp." .. lsp)
        if ok then
          opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, { [lsp] = config })
        end
        if hints then
          opts.inlayHints = opts.inlayHints or {}
          opts.inlayHints[lsp] = true
        end
      end,
    },
    {
      "williamboman/mason-lspconfig",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, lsp)
      end,
    },
  }
end

M.addDap = function(s)
  return {
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, s)
      end,
    },
  }
end

---@param ft string
---@param linter_name string | table<string>
---@param impl lint.Linter?
M.addLinter = function(ft, linter_name, impl)
  local lint = require("lint")
  if impl ~= nil then
    lint.linters[linter_name] = impl
  end

  return {
    {
      "mfussenegger/nvim-lint",
      opts = function(_, opts)
        opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, { [ft] = { linter_name } })
        opts.custom_linters = opts.custom_linters or {}
        opts.custom_linters[linter_name] = lint.linters[linter_name]
      end,
    },
  }
end

return M
