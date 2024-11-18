local Lang = require("util.lang")

return Lang.makeSpec({
  ---@module "conform"
  {
    "stevearc/conform.nvim",
    ---@param opts conform.setupOpts
    ---@type conform.FormatterConfig
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.plsql_format = function(bufnr)
        local args = {
          "-jar",
          "/Users/charlieplate/.local/bin/tvdformat.jar",
          "$FILENAME",
        }

        local xml = vim.fs.find({ ".plsql_format.xml" }, { upward = true, limit = 1, path = vim.fn.expand("%:p:h") })
        if xml[1] ~= nil then
          vim.list_extend(args, { "-xml=" .. xml[1] })
        end

        return {
          command = "java",
          args = args,
          stdin = false,
        }
      end

      -- opts.formatters_by_ft.sql = { "plsql_format" }
      return opts
    end,
  },
})
