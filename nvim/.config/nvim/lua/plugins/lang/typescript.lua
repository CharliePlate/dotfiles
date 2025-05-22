local Dap = require("util.dap")
local Lang = require("util.lang")

--[[ ---@type function
---@return lint.Linter
local tslint_setup = function()
  return {
    cmd = function()
      local local_binary = vim.fn.fnamemodify("./node_modules/.bin/" .. "tslint", ":p")
      return vim.loop.fs_stat(local_binary) and local_binary or "tslint"
    end,
    name = "tslint",
    cwd = vim.fn.fnamemodify(
      vim.fs.find("tslint.json", { path = vim.api.nvim_buf_get_name(0), upward = true })[1],
      ":h"
    ),
    ignore_exitcode = true,
    args = {
      "-c",
      "tslint.json",
      "-t",
      "json",
      "-e",
      "node_modules",
    },
    parser = function(output, bufnr)
      local trimmed_output = vim.trim(output)
      if trimmed_output == "" then
        return {}
      end
      local decode_opts = { luanil = { object = true, array = true } }
      local ok, data = pcall(vim.json.decode, output, decode_opts)
      if not ok then
        return {
          {
            bufnr = bufnr,
            lnum = 0,
            col = 0,
            message = "Could not parse linter output due to: " .. data .. "\noutput: " .. output,
          },
        }
      end

      local diag = {}
      for _, issue in ipairs(data) do
        local diagEntry = {}
        diagEntry.lnum = issue.startPosition.line
        diagEntry.col = issue.startPosition.character
        diagEntry.message = issue.failure
        diagEntry.code = issue.ruleName
        diagEntry.severity = issue.ruleSeverity == "ERROR" and vim.lsp.protocol.DiagnosticSeverity.Error
          or vim.lsp.protocol.DiagnosticSeverity.Warning
        diagEntry.end_lnum = issue.endPosition.line
        diagEntry.end_col = issue.endPosition.character
        diagEntry.source = "tslint"

        table.insert(diag, diagEntry)
      end

      return diag
    end,
    stdin = false,
    append_fname = true,
    stream = "stdout",
  }
end ]]

return Lang.makeSpec({
  -- Lang.addLspServer("tsserver"),
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    event = "BufEnter",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        tsserver_max_memory = "auto",
        tsserver_plugins = { "@vue/typescript-plugin" },
        tsserver_file_preferences = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
    },
  },
  Lang.addFormatter({
    typescript = { "prettierd" },
    javascript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd" },
  }),
  Lang.addLspServer("svelte"),
  Lang.addDap("js-debug-adapter"),
  Lang.addTreesitterFiletypes({ "typescript", "javascript" }),
  -- Lang.addLinter("typescript", "tslint", tslint_setup),
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              vim.fn.expand("$MASON/packages/js-debug-adapter") .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs({ "typescript", "typescriptreact", "javascriptreact" }) do
        if not dap.configurations[language] and not Dap.root_is_configured() then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              console = "integratedTerminal",
              outFiles = { "${workspaceFolder}/dist/**/*.js" },
              -- runtimeExecutable = "/Users/charlieplate/.yarn/bin/ts-node",
            },
          }
        end
      end
    end,
  },
  {
    "David-Kunz/jester",
    opts = {
      cmd = "npx jest -t '$result' -- $file", -- run command
      identifiers = { "test", "it" }, -- used to identify tests
      prepend = { "describe" }, -- prepend describe blocks
      expressions = { "call_expression" }, -- tree-sitter object used to scan for tests/describe blocks
      path_to_jest_run = "jest", -- used to run tests
      path_to_jest_debug = "/Users/charlieplate/graphite/graphite/node_modules/.bin/jest", -- used to debug tests
      terminal_cmd = ":vsplit | terminal", -- used to spawn a terminal for running tests, for debugging refer to nvim-dap's config
      dap = { -- debug adapter configuration
        type = "pwa-node",
        request = "launch",
        port = 9231,
        name = "Jest",
        sourceMaps = true,
        protocol = "inspector",
        runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
        console = "integratedTerminal",
        resolveSourceMapLocations = {
          "${workspaceFolder}/dist/**/*.js",
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        webRoot = "${workspaceFolder}/src",
        remoteRoot = "${workspaceFolder}/src",
      },
    },
    --stylua: ignore
    keys = {
      { "<leader>dtd", function() require("jester").debug() end, desc = "Debug test" },
      { "<leader>dtf", function() require("jester").run_file() end, desc = "Run file" },
      { "<leader>dtr", function() require("jester").run() end, desc = "Run file" },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
    },
    opts = function(_, opts)
      return {
        adapters = vim.list_extend(opts.adapters or {}, {
          require("neotest-jest")({
            jestCommand = "npx jest",
            strategy_config = {
              type = "pwa-node",
              request = "launch",
              webRoot = "${workspaceFolder}/src",
              remoteRoot = "${workspaceFolder}/src",
              runtimeArgs = {
                "--inspect-brk",
                "./node_modules/.bin/jest",
                "--no-coverage",
                "-t",
                "",
              },
              args = { "--no-cache" },
              console = "integratedTerminal",
              cwd = vim.fn.getcwd(),
            },
          }),
        }),
      }
    end,
  },
  -- {
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   dir = vim.fn.stdpath("config") .. "/lua/dev/ts-pretty-errors",
  -- },
})
