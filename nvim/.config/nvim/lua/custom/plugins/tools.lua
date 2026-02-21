return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 2000,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        json = { "prettierd" },
        yaml = { "prettierd" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = function(_, opts)
      return {
        adapters = vim.list_extend(opts.adapters or {}, {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            recursive_run = true,
            args = { "-count=1", "-timeout=60s" },
          }),
        }),
      }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      local goci = lint.linters.golangcilint
      goci.args = {
        "run",
        "--output.json.path=stdout",
        "--issues-exit-code=0",
        "--show-stats=false",
        "--output.text.print-issued-lines=false",
        "--output.text.print-linter-name=false",
        function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        end,
      }

      lint.linters_by_ft = {
        go = { "golangcilint" },
        gomod = { "golangcilint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "nvim-orgmode/orgmode",
    lazy = false,
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/orgfiles/**/*" },
        org_default_notes_file = "~/orgfiles/refile.org",
        org_startup_folded = "showeverything",
        mappings = {
          org = {
            org_toggle_checkbox = "<leader>ox",
          },
        },
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:CREATED: %U\n:END:\n",
            target = "~/orgfiles/refile.org",
          },
        },
      })

      vim.lsp.enable("org")
    end,
  },
}
