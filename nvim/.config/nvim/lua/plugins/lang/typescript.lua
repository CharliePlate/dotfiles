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
    opts = {},
  },
  Lang.addFormatter({
    typescript = { "prettierd" },
    javascript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd" },
  }),
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
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
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
              runtimeExecutable = "/Users/charlieplate/.yarn/bin/ts-node",
            },
          }
        end
      end
    end,
  },
  {
    "David-Kunz/jester",
    opts = {
      cmd = "jest -t '$result' -- $file", -- run command
      identifiers = { "test", "it" }, -- used to identify tests
      prepend = { "describe" }, -- prepend describe blocks
      expressions = { "call_expression" }, -- tree-sitter object used to scan for tests/describe blocks
      path_to_jest_run = "jest", -- used to run tests
      path_to_jest_debug = "/Users/charlieplate/.yarn/bin/jest", -- used for debugging
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
    config = function(_, opts)
      require("jester").setup(opts)
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtd",
        "<cmd>lua require'jester'.debug()<cr>",
        { noremap = true, desc = "Debug test" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtr",
        "<cmd>lua require'jester'.run()<cr>",
        { noremap = true, desc = "Run test" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtf",
        "<cmd>lua require'jester'.run_file()<cr>",
        { noremap = true, desc = "Run file" }
      )
    end,
    ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
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
          require("neotest-jest")({}),
        }),
      }
    end,
  },
  -- {
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   dir = vim.fn.stdpath("config") .. "/lua/dev/ts-pretty-errors",
  -- },
})
